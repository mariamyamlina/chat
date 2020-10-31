//
//  ChatRequest.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
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
    
    func save(messages: [Message], inChannel channel: Channel, completion: @escaping () -> Void) {
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
    
    func load(channel id: String, from context: NSManagedObjectContext) -> ChannelDB? {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func load(message id: String, from context: NSManagedObjectContext) -> MessageDB? {
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
    
    func delete(compareWithChannels channels: [Channel], in context: NSManagedObjectContext) {
        var ids: [String] = []
        channels.forEach {
            ids.append($0.identifier)
        }
        var idsFromDB: [String] = []
        
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        do {
            let channelsDB = try context.fetch(request)
            channelsDB.forEach {
                idsFromDB.append($0.identifier)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        idsFromDB = idsFromDB.filter { !ids.contains($0) }

        if !idsFromDB.isEmpty {
            idsFromDB.forEach {
                let predicate = NSPredicate(format: "identifier = %@", $0)
                request.predicate = predicate
                do {
                    let channel = try context.fetch(request).first
                    guard let unwrChannel = channel else { return }
                    let object = context.object(with: unwrChannel.objectID)
                    context.delete(object)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func delete(compareWithMessages messages: [Message], inChannel channelDB: ChannelDB, in context: NSManagedObjectContext) {
        var ids: [String] = []
        messages.forEach {
            ids.append($0.identifier)
        }
        var idsFromDB: [String] = []
        
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        do {
            let messagesDB = try context.fetch(request)
            messagesDB.forEach {
                idsFromDB.append($0.identifier)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        idsFromDB = idsFromDB.filter { !ids.contains($0) }

        if !idsFromDB.isEmpty {
            idsFromDB.forEach {
                let predicate = NSPredicate(format: "identifier = %@", $0)
                request.predicate = predicate
                do {
                    let message = try context.fetch(request).first
                    guard let unwrMessage = message else { return }
                    channelDB.removeFromMessages(unwrMessage)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
