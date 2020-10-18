//
//  ViewModelFactory.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ViewModelFactory {
    func channelToCell(_ channel: Channel) -> ConversationTableViewCell.ConversationCellModel {
        let cellModel = ConversationTableViewCell.ConversationCellModel(name: channel.name,
                                                                        message: channel.lastMessage ?? "No messages yet",
                                                                        date: channel.lastActivity ?? Date(timeInterval: -50000000000, since: Date()),
                                                                        isOnline: true,
                                                                        hasUnreadMessages: false)
        return cellModel
    }

    func messageToCell(_ message: Message, _ messageType: MessageTableViewCell.MessageType) -> MessageTableViewCell.MessageCellModel {
        var messageModel: MessageTableViewCell.MessageCellModel = MessageTableViewCell.MessageCellModel(text: message.content, time: message.created, type: .input)

        switch messageType {
        case .input:
            messageModel = MessageTableViewCell.MessageCellModel(text: "\(message.senderName)\n\(message.content)", time: message.created, type: .input)
        case .output:
            messageModel = MessageTableViewCell.MessageCellModel(text: message.content, time: message.created, type: .output)
        }
        return messageModel
    }
}
