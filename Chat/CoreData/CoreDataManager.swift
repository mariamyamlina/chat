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
    
    func saveToDB(channels: [Channel]) {
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
                guard loadChannelFromDB(with: channel.identifier, in: context) == nil else { continue }
                _ = ChannelDB(identifier: channel.identifier,
                                          name: channel.name,
                                          lastMessage: channel.lastMessage,
                                          lastActivity: channel.lastActivity,
                                          in: context)
            }
        }
    }
    
    func saveToDB(messages: [Message], in channel: Channel) {
        coreDataStack.performSave { context in
            // MARK: - FIRST OPTION
            // --- FIRST OPTION (WITHOUT FETCH REQUEST) ---
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
            guard let channel = loadChannelFromDB(with: channel.identifier, in: context) else { return }
            for message in messages {
                guard loadMessageFromDB(with: message.identifier, in: context) == nil else { continue }
                let messageDB = MessageDB(identifier: message.identifier,
                                          content: message.content,
                                          created: message.created,
                                          senderId: message.senderId,
                                          senderName: message.senderName,
                                          in: context)
                channel.addToMessages(messageDB)
            }
        }
    }
    
    // MARK: - Load
    
    func loadChannelFromDB(with id: String, in context: NSManagedObjectContext) -> ChannelDB? {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadMessageFromDB(with id: String, in context: NSManagedObjectContext) -> MessageDB? {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", id)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
