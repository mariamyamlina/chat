//
//  ViewModelFactory.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ViewModelFactory {
    typealias ChannelModel = ConversationTableViewCell.ConversationCellModel
    typealias MessageModel = MessageTableViewCell.MessageCellModel
    typealias MessageType = MessageTableViewCell.MessageType
    
    // MARK: - Channel
    
    func channelToCell(_ channel: Channel, _ image: UIImage?) -> ChannelModel {
        let cellModel = ChannelModel(name: channel.name,
                                     message: channel.lastMessage ?? "No messages yet",
                                     date: channel.lastActivity,
                                     image: image,
                                     isOnline: true,
                                     hasUnreadMessages: false)
        return cellModel
    }
    
    // MARK: - Message

    func messageToCell(_ message: Message, _ messageType: MessageType) -> MessageModel {
        var messageModel = MessageModel(text: message.content,
                                        time: message.created,
                                        type: .input)
        switch messageType {
        case .input:
            var senderName = message.senderName
            if containtsOnlyOfWhitespaces(string: message.senderName) {
                senderName = "UNKNOWN SENDER"
            }
            messageModel = MessageModel(text: "\(senderName)\n\(message.content)",
                                                                time: message.created,
                                                                type: .input)
        case .output:
            messageModel = MessageModel(text: message.content,
                                        time: message.created,
                                        type: .output)
        }
        return messageModel
    }
}
