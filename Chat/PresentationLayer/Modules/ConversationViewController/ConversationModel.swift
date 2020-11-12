//
//  ConversationModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import CoreData

// MARK: - MessageCellModel
struct MessageCellModel {
    let text: String
    let time: Date
    let type: MessageTableViewCell.MessageType
}

// MARK: - MessageModelFactory
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

// MARK: - ConversationModel
protocol IConversationModel: class {
    var channel: Channel? { get }
    func getMessages(inChannel channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func createMessage(withText text: String, inChannel channel: Channel)
    func removeListener()
    var frc: NSFetchedResultsController<MessageDB> { get }
    var currentTheme: Theme { get }
    func message(at indexPath: IndexPath) -> Message
    func messageModel(at indexPath: IndexPath) -> MessageCellModel
}

class ConversationModel {
    // MARK: - Dependencies
    var channel: Channel?
    let messageService: IMessageService
    var settingsService: ISettingsService
    var fetchService: IFetchService
    
    // MARK: - Init / deinit
    init(messageService: IMessageService, settingsService: ISettingsService, fetchService: IFetchService, channel: Channel?) {
        self.messageService = messageService
        self.channel = channel
        self.settingsService = settingsService
        self.fetchService = fetchService
    }
    
    lazy var frc: NSFetchedResultsController<MessageDB> = {
        return fetchService.getFRC(entityType: .message,
                                   channelId: channel?.identifier,
                                   sectionNameKeyPath: "formattedDate",
                                   cacheName: "Messages in channel with id \(String(describing: channel?.identifier))")
    }()
}

// MARK: - IConversationModel
extension ConversationModel: IConversationModel {
    func getMessages(inChannel channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        messageService.getMessages(in: channel, errorHandler: errorHandler)
    }
    
    func createMessage(withText text: String, inChannel channel: Channel) {
        messageService.create(message: text, in: channel)
    }
    
    func removeListener() {
        messageService.removeListener()
    }
    
    var currentTheme: Theme {
        return settingsService.currentTheme
    }
    
    func message(at indexPath: IndexPath) -> Message {
        let messageDB = frc.object(at: indexPath)
        return Message(from: messageDB)
    }
    
    func messageModel(at indexPath: IndexPath) -> MessageCellModel {
        let message = self.message(at: indexPath)
        let messageCellFactory = MessageModelFactory()
        if message.senderId == messageService.universallyUniqueIdentifier {
            return messageCellFactory.messageToCell(message, .output)
        } else {
            return messageCellFactory.messageToCell(message, .input)
        }
    }
}
