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
    
    // TODO: - Вынести в отдельную очередь
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
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
    
    let group = DispatchGroup()
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
//        let context = saveContext()
//        context.performAndWait {
//            block(context)
//            if context.hasChanges {
//                do {
//                    group.enter()
//                    group.enter()
//                    group.enter()
//                    try self.performSave(in: context)
//                    group.wait()
//                } catch {
//                    assertionFailure(error.localizedDescription)
//                }
//            }
//        }
        
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try self.performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
//
//        let savecontext = saveContext()
//        savecontext.performAndWait {
//            block(savecontext)
//            if savecontext.hasChanges {
//                do {
//                    try savecontext.save()
//
//                    let maincontext = savecontext.parent
//                    maincontext?.performAndWait {
//                        if let maincontextHasChanges = maincontext?.hasChanges, maincontextHasChanges {
//                            do {
//                                try maincontext?.save()
//
//                                let writtercontext = maincontext?.parent
//                                writtercontext?.performAndWait {
//                                    if let writtercontextHasChanges = writtercontext?.hasChanges, writtercontextHasChanges {
//                                        do {
//                                            try writtercontext?.save()
//                                        } catch {
//                                            assertionFailure(error.localizedDescription)
//                                        }
//                                    }
//                                }
//                            } catch {
//                                assertionFailure(error.localizedDescription)
//                            }
//                        }
//                    }
//                } catch {
//                    assertionFailure(error.localizedDescription)
//                }
//            }
//        }
    }

    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            parent.performAndWait {
                do {
                    try performSave(in: parent)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
        
//        if context == mainContext {
//
//        } else {
//            try context.save()
//            self.group.leave()
//            if let contextParent = context.parent {
//                DispatchQueue.main.async {
//                    do {
//                        try contextParent.save()
//                        self.group.leave()
//                    } catch { }
//                }
//                if let contextGrandParent = contextParent.parent {
//                    try contextGrandParent.save()
//                    group.leave()
//                }
//            }
//        }
        
//        print(context == mainContext)
//        if context == mainContext {
//            DispatchQueue.main.async {
//                do {
//                    try context.save()
//                    self.group.leave()
//                } catch { }
//            }
//        } else {
//            try context.save()
//            group.leave()
//        }
//        if let parent = context.parent {
//            try self.performSave(in: parent)
//        }
    }
    
    // MARK: - Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("Добавлено объектов:", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("Обновлено объектов:", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            print("Удалено объектов:", deletes.count)
        }
    }
    
    // MARK: - CoreData Logs
    
    func printDatabaseStatistics() {
        mainContext.perform {
            var counter = 1
            do {
                let count = try self.mainContext.count(for: ChannelDB.fetchRequest())
                print("\(count) каналов")
                let array = try self.mainContext.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
                array.forEach {
                    print("\(counter). \($0.about)")
                    counter += 1
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
