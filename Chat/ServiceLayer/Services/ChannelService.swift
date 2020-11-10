//
//  ChannelService.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelServiceProtocol {
    var channelsFetchedResultsController: NSFetchedResultsController<ChannelDB> { get }
    
    func save(channels: [Channel], errorHandler: @escaping (String?, String?) -> Void)
    func save(channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func update(channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func delete(channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
}

class ChannelService: ChannelServiceProtocol {
    let coreDataStack: CoreDataStackProtocol
    
    // MARK: - Init / deinit

    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    lazy var channelsFetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest = NSFetchRequest<ChannelDB>()
        fetchRequest.entity = ChannelDB.entity()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.shared.mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: "Channels")
    }()
    
    func save(channels: [Channel],
              errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { [weak self] context in
            for channel in channels {
                let channelFromDB = self?.load(channel: channel.identifier, from: context, errorHandler: errorHandler)
                if channelFromDB == nil {
                    let channelDB = ChannelDB(identifier: channel.identifier,
                                  name: channel.name,
                                  lastMessage: channel.lastMessage,
                                  lastActivity: channel.lastActivity,
                                  in: context)
                    do {
                        try context.obtainPermanentIDs(for: [channelDB])
                    } catch {
                        errorHandler("CoreData", error.localizedDescription)
                    }
                } else {
                    if channelFromDB?.lastActivity != channel.lastActivity || channelFromDB?.lastMessage != channel.lastMessage {
                        channelFromDB?.lastActivity = channel.lastActivity
                        channelFromDB?.lastMessage = channel.lastMessage
                    }

                    continue
                }
            }

            self?.delete(compareWithChannels: channels, errorHandler: errorHandler)
        }
    }
    
    func save(channel: Channel,
              errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { [weak self] context in
            guard self?.load(channel: channel.identifier, from: context, errorHandler: errorHandler) == nil else { return }
            let channelDB = ChannelDB(identifier: channel.identifier,
                          name: channel.name,
                          lastMessage: channel.lastMessage,
                          lastActivity: channel.lastActivity,
                          in: context)
            do {
                try context.obtainPermanentIDs(for: [channelDB])
            } catch {
                errorHandler("CoreData", error.localizedDescription)
            }
        }
    }
    
    func update(channel: Channel,
                errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { [weak self] context in
            guard let channelFromDB = self?.load(channel: channel.identifier, from: context, errorHandler: errorHandler) else { return }
            if channelFromDB.lastActivity != channel.lastActivity && channelFromDB.lastMessage != channel.lastMessage {
                channelFromDB.lastActivity = channel.lastActivity
                channelFromDB.lastMessage = channel.lastMessage
            }
        }
    }
    
    private func load(channel id: String,
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
    
    private func delete(compareWithChannels channels: [Channel],
                errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Channel")
            arrayDifference(request: request, arrayOfEntities: channels, in: context, errorHandler: errorHandler).forEach {
                let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", $0)
                fetchRequest.predicate = predicate
                do {
                    let channelDB = try context.fetch(fetchRequest).first
                    guard let channel = channelDB else { return }
                    let object = context.object(with: channel.objectID)
                    context.delete(object)
                } catch {
                    errorHandler("CoreData", error.localizedDescription)
                }
            }
        }
    }
    
    func delete(channel: Channel,
                errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { [weak self] context in
            guard let channelFromDB = self?.load(channel: channel.identifier, from: context, errorHandler: errorHandler) else { return }
            let object = context.object(with: channelFromDB.objectID)
            context.delete(object)
        }
    }
    
    private func arrayDifference(request: NSFetchRequest<NSFetchRequestResult>,
                         arrayOfEntities: [EntityProtocol],
                         in context: NSManagedObjectContext,
                         errorHandler: @escaping (String?, String?) -> Void) -> [String] {
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
