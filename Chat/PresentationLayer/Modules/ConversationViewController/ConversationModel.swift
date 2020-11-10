//
//  ConversationModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
// TODO: - Убрать CoreData отсюда
import CoreData

struct MessageCellModel {
    let text: String
    let time: Date
    let type: MessageTableViewCell.MessageType
}

class MessageModelFactory {
    func messageToCell(_ message: Message, _ messageType: MessageTableViewCell.MessageType) -> MessageCellModel {
        var messageModel = MessageCellModel(text: message.content,
                                        time: message.created,
                                        type: .input)
        switch messageType {
        case .input:
            var senderName = message.senderName
            if message.senderName.containtsOnlyOfWhitespaces() {
                senderName = "UNKNOWN SENDER"
            }
            messageModel = MessageCellModel(text: "\(senderName)\n\(message.content)",
                                                                time: message.created,
                                                                type: .input)
        case .output:
            messageModel = MessageCellModel(text: message.content,
                                        time: message.created,
                                        type: .output)
        }
        return messageModel
    }
}

protocol ConversationModelProtocol: class {
    // TODO: - Разобраться с делегатом дважды
    var delegate: ConversationModelDelegate? { get set }
    var channel: Channel? { get }
    func universallyUniqueIdentifier() -> String
    func getMessages(inChannel channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func createMessage(withText text: String, inChannel channel: Channel)
    func removeListener()
    func fetchMessages() -> NSFetchedResultsController<MessageDB>?
}

protocol ConversationModelDelegate: class {
    func setup(dataSource: [MessageCellModel])
    // TODO: - Разобраться с этой функцией дважды
    func show(error message: String)
}

class ConversationModel: ConversationModelProtocol {
    weak var delegate: ConversationModelDelegate?
    var channel: Channel?
    let firebaseService: FirebaseServiceProtocol
    let fetchService: FetchServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol, fetchService: FetchServiceProtocol, channel: Channel?) {
        self.firebaseService = firebaseService
        self.fetchService = fetchService
        self.channel = channel
    }
    
    func universallyUniqueIdentifier() -> String {
        return firebaseService.universallyUniqueIdentifier
    }
    
    func getMessages(inChannel channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        firebaseService.getMessages(in: channel, errorHandler: errorHandler)
    }
    
    func createMessage(withText text: String, inChannel channel: Channel) {
        firebaseService.create(message: text, in: channel)
    }
    
    func removeListener() {
        firebaseService.removeMessagesListener()
    }
    
    func fetchMessages() -> NSFetchedResultsController<MessageDB>? {
        return fetchService.messagesFetchedResultsController
    }
}
