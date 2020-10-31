//
//  ChatRequest.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    let coreDataStack: CoreDataStack
    
    // MARK: - Singleton
    
    static var shared: CoreDataManager = {
        return CoreDataManager(coreDataStack: CoreDataStack.shared)
    }()
    private init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Save
    
    func save(channels: [Channel]) {
        coreDataStack.performSave { context in
            for channel in channels {
                let channelFromDB = self.load(channel: channel.identifier, from: context)
                if channelFromDB == nil {
                    let channelDB = ChannelDB(identifier: channel.identifier,
                                  name: channel.name,
                                  lastMessage: channel.lastMessage,
                                  lastActivity: channel.lastActivity,
                                  in: context)
                    do {
                        try context.obtainPermanentIDs(for: [channelDB])
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    if channelFromDB?.lastActivity != channel.lastActivity || channelFromDB?.lastMessage != channel.lastMessage {
                        channelFromDB?.lastActivity = channel.lastActivity
                        channelFromDB?.lastMessage = channel.lastMessage
                    }

                    continue
                }
            }

            self.delete(compareWithChannels: channels, in: context)
        }
    }
    
    func save(messages: [Message],
              inChannel channel: Channel,
              completion: @escaping () -> Void) {
        coreDataStack.performSave { context in
            guard let channel = self.load(channel: channel.identifier, from: context) else { return }
            for message in messages {
                guard self.load(message: message.identifier, from: context) == nil else { continue }
                let messageDB = MessageDB(identifier: message.identifier,
                                          content: message.content,
                                          created: message.created,
                                          senderId: message.senderId,
                                          senderName: message.senderName,
                                          in: context)
                do {
                    try context.obtainPermanentIDs(for: [messageDB])
                } catch {
                    print(error.localizedDescription)
                }
                channel.addToMessages(messageDB)
            }

            self.delete(compareWithMessages: messages, inChannel: channel, in: context)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - Load
    
    func load(channel id: String,
              from context: NSManagedObjectContext) -> ChannelDB? {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func load(message id: String,
              from context: NSManagedObjectContext) -> MessageDB? {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Delete
    
    func delete(compareWithChannels channels: [Channel],
                in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Channel")

        arrayDifference(request: request, arrayOfEntities: channels, in: context).forEach {
            let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            let predicate = NSPredicate(format: "identifier = %@", $0)
            fetchRequest.predicate = predicate
            do {
                let channelDB = try context.fetch(fetchRequest).first
                guard let channel = channelDB else { return }
                let object = context.object(with: channel.objectID)
                context.delete(object)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func delete(compareWithMessages messages: [Message],
                inChannel channelDB: ChannelDB,
                in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let predicate = NSPredicate(format: "channel.identifier = %@", channelDB.identifier)
        request.predicate = predicate

        arrayDifference(request: request, arrayOfEntities: messages, in: context).forEach {
            let fetchRequest: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
            let predicate = NSPredicate(format: "identifier = %@", $0)
            fetchRequest.predicate = predicate
            do {
                let messageDB = try context.fetch(fetchRequest).first
                guard let message = messageDB else { return }
                channelDB.removeFromMessages(message)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func arrayDifference(request: NSFetchRequest<NSFetchRequestResult>,
                         arrayOfEntities: [EntityProtocol],
                         in context: NSManagedObjectContext) -> [String] {
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
            fatalError(error.localizedDescription)
        }

        arrayOfEntities.forEach {
            subtrahend.append($0.identifier)
        }

        return Array(Set(decreasing).subtracting(subtrahend))
    }
}
