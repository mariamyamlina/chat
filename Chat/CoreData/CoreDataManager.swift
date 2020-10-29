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
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Save
    
    func save(channels: [Channel]) {
        coreDataStack.performSave { context in
            
            // MARK: - FIRST OPTION
            // --- FIRST OPTION (WITHOUT FETCH REQUEST) ---
//            channels.forEach {
//                _ = ChannelDB(identifier: $0.identifier,
//                              name: $0.name,
//                              lastMessage: $0.lastMessage,
//                              lastActivity: $0.lastActivity,
//                              in: context)
//            }
            
            // MARK: - SECOND OPTION
            // --- SECOND OPTION (WITH FETCH REQUEST) ---
            for channel in channels {
                let channelFromDB = self.loadChannel(with: channel.identifier, in: context)
                if channelFromDB == nil {
                    _ = ChannelDB(identifier: channel.identifier,
                                  name: channel.name,
                                  lastMessage: channel.lastMessage,
                                  lastActivity: channel.lastActivity,
                                  in: context)
                } else {
                    if channelFromDB?.lastActivity != channel.lastActivity || channelFromDB?.lastMessage != channel.lastMessage {
                        channelFromDB?.lastActivity = channel.lastActivity
                        channelFromDB?.lastMessage = channel.lastMessage
                    }

                    continue
                }
            }

            self.deleteChannels(compareWith: channels, in: context)
        }
    }
    
    func save(messages: [Message], in channel: Channel) {
        coreDataStack.performSave { context in
            
            // MARK: - FIRST OPTION
//             --- FIRST OPTION (WITHOUT FETCH REQUEST) ---
//            var messagesDB: [MessageDB] = []
//            messages.forEach {
//                messagesDB.append(MessageDB(identifier: $0.identifier,
//                                            content: $0.content,
//                                            created: $0.created,
//                                            senderId: $0.senderId,
//                                            senderName: $0.senderName,
//                                            in: context))
//            }
//            let channelDB = ChannelDB(identifier: channel.identifier,
//                                      name: channel.name,
//                                      lastMessage: channel.lastMessage,
//                                      lastActivity: channel.lastActivity,
//                                      in: context)
//            messagesDB.forEach {
//                channelDB.addToMessages($0)
//            }
            
            // MARK: - SECOND OPTION
            // --- SECOND OPTION (WITH FETCH REQUEST) ---
            guard let channel = self.loadChannel(with: channel.identifier, in: context) else { return }
            for message in messages {
                guard self.loadMessage(with: message.identifier, in: context) == nil else { continue }
                let messageDB = MessageDB(identifier: message.identifier,
                                          content: message.content,
                                          created: message.created,
                                          senderId: message.senderId,
                                          senderName: message.senderName,
                                          in: context)
                channel.addToMessages(messageDB)
            }

            self.deleteMessages(compareWith: messages, in: context)
        }
    }
    
    // MARK: - Load
    
    func loadChannel(with id: String, in context: NSManagedObjectContext) -> ChannelDB? {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadMessage(with id: String, in context: NSManagedObjectContext) -> MessageDB? {
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
    
    func deleteChannels(compareWith channels: [Channel], in context: NSManagedObjectContext) {
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
    
    func deleteMessages(compareWith messages: [Message], in context: NSManagedObjectContext) {
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
                    let object = context.object(with: unwrMessage.objectID)
                    context.delete(object)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
