//
//  CoreDataStack.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    var delegate: CoreDataStackDelegate? { get set }
    var mainContext: NSManagedObjectContext { get }
    func performSave(_ handler: (NSManagedObjectContext) -> Void)
    func load(channel id: String, from context: NSManagedObjectContext,
              errorHandler: @escaping (String?, String?) -> Void) -> ChannelDB?
    func load(message id: String, from context: NSManagedObjectContext,
              errorHandler: @escaping (String?, String?) -> Void) -> MessageDB?
    func enableObservers()
    func arrayDifference(entityType: ModelType, predicate: String?, arrayOfEntities: [IModel], in context: NSManagedObjectContext,
                         errorHandler: @escaping (String?, String?) -> Void) -> [String]
    func fetchRequest<T: NSManagedObject>(for entity: ModelType, channelId: String?) -> NSFetchRequest<T>
    func fetchRequest<T: NSManagedObject>(for entity: ModelType, with identifier: String) -> NSFetchRequest<T>
}

protocol CoreDataStackDelegate {
    func printLog(_ modificationType: String, _ count: Int)
    func printStatLog(_ channelsCount: Int, _ messagesCount: Int, _ infoAbout: [String])
}

class CoreDataStack: ICoreDataStack {
    // MARK: - Dependencies
    var delegate: CoreDataStackDelegate?
    
    // MARK: - Init / deinit
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
    func performSave(_ handler: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            handler(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }

    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    // MARK: - Load Context
    func load(channel id: String,
              from context: NSManagedObjectContext,
              errorHandler: @escaping (String?, String?) -> Void) -> ChannelDB? {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            errorHandler("CoreData", error.localizedDescription)
            return nil
        }
    }
    
    func load(message id: String,
              from context: NSManagedObjectContext,
              errorHandler: @escaping (String?, String?) -> Void) -> MessageDB? {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            errorHandler("CoreData", error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Requests
    func fetchRequest<T: NSManagedObject>(for entity: ModelType, with identifier: String) -> NSFetchRequest<T> {
        let fetchRequest: NSFetchRequest<T>
        switch entity {
        case .channel:
            let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            request.entity = ChannelDB.entity()
            fetchRequest = request as? NSFetchRequest<T> ?? NSFetchRequest<T>()
        case .message:
            let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
            request.entity = MessageDB.entity()
            fetchRequest = request as? NSFetchRequest<T> ?? NSFetchRequest<T>()
        }
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    func fetchRequest<T: NSManagedObject>(for entity: ModelType, channelId: String?) -> NSFetchRequest<T> {
        let fetchRequest: NSFetchRequest<T>
        let sortDescriptor: NSSortDescriptor
        switch entity {
        case .channel:
            let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            request.entity = ChannelDB.entity()
            sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
            fetchRequest = request as? NSFetchRequest<T> ?? NSFetchRequest<T>()
        case .message:
            let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
            request.entity = MessageDB.entity()
            let predicate = NSPredicate(format: "channel.identifier = %@", channelId ?? "")
            request.predicate = predicate
            sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
            fetchRequest = request as? NSFetchRequest<T> ?? NSFetchRequest<T>()
        }
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        return fetchRequest
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
        printDatabaseStatistics()
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            delegate?.printLog("Deleted", deletes.count)
        }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            delegate?.printLog("Added", inserts.count)
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            delegate?.printLog("Updated", updates.count)
        }
    }
    
    // MARK: - CoreData Logs
    private func printDatabaseStatistics() {
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
                self.delegate?.printStatLog(channelsCount, messagesCount, description)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Array Difference
    func arrayDifference(entityType: ModelType,
                         predicate: String?,
                         arrayOfEntities: [IModel],
                         in context: NSManagedObjectContext,
                         errorHandler: @escaping (String?, String?) -> Void) -> [String] {
        let request: NSFetchRequest<NSFetchRequestResult>
        if entityType == .channel {
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Channel")
        } else {
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            let predicate = NSPredicate(format: "channel.identifier = %@", predicate ?? "")
            request.predicate = predicate
        }
        
        var decreasing: [String] = []
        var subtrahend: [String] = []
        
        request.propertiesToFetch = ["identifier"]
        request.returnsDistinctResults = true
        request.resultType = .dictionaryResultType
        do {
            let dict = try context.fetch(request)
            guard let result = dict as? [[String: String]] else { return [] }
            decreasing = result.map { ($0["identifier"] ?? "") }
        } catch {
            errorHandler("CoreData", error.localizedDescription)
        }

        arrayOfEntities.forEach {
            subtrahend.append($0.identifier)
        }

        return Array(Set(decreasing).subtracting(subtrahend))
    }
}
