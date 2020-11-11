//
//  MessageService.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

protocol MessageServiceProtocol {
    var channel: Channel? { get }
//    var messagesFetchedResultsController: NSFetchedResultsController<MessageDB> { get }
    var universallyUniqueIdentifier: String { get }
    func getMessages(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func addListener(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func removeListener()
    func create(message text: String, in channel: Channel)
}

class MessageService {
    let coreDataStack: CoreDataStackProtocol
    let firebaseManager: FirebaseManagerProtocol
    var universallyUniqueIdentifier: String
    let channel: Channel?
    
    // MARK: - Init / deinit
    init(coreDataStack: CoreDataStackProtocol, firebaseManager: FirebaseManagerProtocol, channel: Channel?) {
        self.coreDataStack = coreDataStack
        self.channel = channel
        self.firebaseManager = firebaseManager
        self.universallyUniqueIdentifier = firebaseManager.universallyUniqueIdentifier
    }
    
    // MARK: - Save
    private func save(messages: [Message],
                      inChannel channel: Channel,
                      errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { [weak self] context in
            guard let channelDB = coreDataStack.load(channel: channel.identifier,
                                                     from: context, errorHandler: errorHandler) else { return }
            for message in messages {
                guard coreDataStack.load(message: message.identifier,
                                         from: context, errorHandler: errorHandler) == nil else { continue }
                let messageDB = MessageDB(identifier: message.identifier,
                                          content: message.content,
                                          created: message.created,
                                          senderId: message.senderId,
                                          senderName: message.senderName,
                                          in: context)
                do {
                    try context.obtainPermanentIDs(for: [messageDB])
                } catch {
                    errorHandler("CoreData", error.localizedDescription)
                }
                channelDB.addToMessages(messageDB)
            }

            self?.delete(compareWithMessages: messages, inChannel: channel, errorHandler: errorHandler)
        }
    }
    
    private func save(message: Message,
                      inChannel channel: Channel,
                      errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            guard let channel = coreDataStack.load(channel: channel.identifier,
                                                   from: context, errorHandler: errorHandler) else { return }
            guard coreDataStack.load(message: message.identifier,
                                     from: context, errorHandler: errorHandler) == nil else { return }
            let messageDB = MessageDB(identifier: message.identifier,
                                      content: message.content,
                                      created: message.created,
                                      senderId: message.senderId,
                                      senderName: message.senderName,
                                      in: context)
            do {
                try context.obtainPermanentIDs(for: [messageDB])
            } catch {
                errorHandler("CoreData", error.localizedDescription)
            }
            channel.addToMessages(messageDB)
        }
    }
    
    // MARK: - Delete
    private func delete(compareWithMessages messages: [Message],
                        inChannel channel: Channel,
                        errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            guard let channelDB = coreDataStack.load(channel: channel.identifier, from: context, errorHandler: errorHandler) else { return }

            coreDataStack.arrayDifference(entityType: .message, predicate: channelDB.identifier, arrayOfEntities: messages,
                                          in: context, errorHandler: errorHandler).forEach {
                let fetchRequest = coreDataStack.fetchRequest(for: .message, with: $0)
                do {
                    let messageDB = try context.fetch(fetchRequest).first as? MessageDB
                    guard let message = messageDB else { return }
                    channelDB.removeFromMessages(message)
                } catch {
                    errorHandler("CoreData", error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - MessageServiceProtocol
extension MessageService: MessageServiceProtocol {
    func getMessages(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.getMessages(in: channel, completion: { [weak self] messages in
            self?.save(messages: messages, inChannel: channel, errorHandler: errorHandler)
            self?.addListener(in: channel, errorHandler: errorHandler)},
                                    errorHandler: errorHandler)
    }
    
    func addListener(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.addMessagesListener(in: channel, completion: { [weak self] (type, message) in
            if type == .added { self?.save(message: message, inChannel: channel, errorHandler: errorHandler) }
            if type == .modified { }
            if type == .removed { }},
                                            errorHandler: errorHandler)
    }
    
    func removeListener() {
        firebaseManager.removeMessagesListener()
    }
    
    func create(message text: String, in channel: Channel) {
        firebaseManager.create(message: text, in: channel)
    }
}