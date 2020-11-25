//
//  CoreDataStack.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    // MARK: - Singleton
    
    static var shared: CoreDataStack = {
        return CoreDataStack()
    }()
    private init() { }
    
    deinit {
        disableObservers()
    }
    
    // MARK: - URL
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).last else {
            fatalError("Document path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataMadelName = "Chat"
    private let dataModelExtension = "momd"
    
    // MARK: - Init Stack
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataMadelName,
                                             withExtension: self.dataModelExtension) else {
            fatalError("Model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("ManagedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    // MARK: - Coordinator

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let queue = DispatchQueue(label: "com.chat.coredata", qos: .background)
        queue.sync {
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: self.storeUrl,
                                                   options: nil)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        return coordinator
    }()
    
    // MARK: - Contexts
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context

    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.perform { [weak self] in
            block(context)
            if context.hasChanges {
                self?.performSave(in: context)
            }
        }
        
        /*
         При использовании FIRST OPTION типа сохранения из файла CoreDataManager.swift при использовании perform в логировании происходит дублирование записей
         При использовании SECOND OPTION типа сохранения из файла CoreDataManager.swift все в порядке
         
         Это происходит из-за того, что в первом случае БД перезатирает данные, как я уже писала в комментарии к дз на портале
         Избежать этого можно, например, так:
         
         context.performAndWait {
             block(context)
             if context.hasChanges {
                 performSave(in: context)
             }
         }
         
         И так... (см. ниже)
         */
    }

    private func performSave(in context: NSManagedObjectContext) {
        context.perform { [weak self] in
            do {
                try context.save()
                if let parent = context.parent {
                    self?.performSave(in: parent)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        
        /*
         ...продолжение:
         
         if context == writterContext {
            context.perform {
                do {
                    try context.save()
                } catch {
                    assertionFailure(error.localizedDescription)
                }
             }
         } else {
            context.performAndWait {
                do {
                    try context.save()
                    if let parent = context.parent {
                        performSave(in: parent)
                    }
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
         }
         
         Но в таком случае часть сохранения будет происходить на мейне, что не есть хорошо
         */
    }
    
    // MARK: - Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    func disableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self,
                                          name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                          object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        didUpdateDataBase?(self)
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            Loger.printDBLog("Deleted", deletes.count)
        }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            Loger.printDBLog("Added", inserts.count)
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            Loger.printDBLog("Updated", updates.count)
        }
    }
    
    // MARK: - CoreData Logs
    
    func printDatabaseStatistics() {
        mainContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                var messagesCount = 0
                var description: [String] = []
                
                let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                let dateSortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
                request.sortDescriptors = [dateSortDescriptor]
                let channelsCount = try self.mainContext.count(for: request)
                let array = try self.mainContext.fetch(request)
                array.forEach {
                    messagesCount += $0.messages?.count ?? 0
                    description.append($0.about)
                }
                Loger.printDBStatLog(channelsCount, messagesCount, description)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
