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

    func messageToCell(_ message: Message) -> MessageTableViewCell.MessageCellModel {
//        var senderName = message.senderName
//        if senderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            senderName = "Unknown sender"
//        }
        
        var messageModel: MessageTableViewCell.MessageCellModel = MessageTableViewCell.MessageCellModel(text: message.content, time: message.created, type: .input)

        if message.senderId == getUniversallyUniqueIdentifier() {
            messageModel = MessageTableViewCell.MessageCellModel(text: message.content, time: message.created, type: .output)
        } else {
            messageModel = MessageTableViewCell.MessageCellModel(text: "\(senderName)\n\(message.content)", time: message.created, type: .input)
        }
        return messageModel
    }
}
