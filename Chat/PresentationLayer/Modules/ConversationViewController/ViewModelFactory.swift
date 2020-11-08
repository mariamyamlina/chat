//
//  MessageModelFactory.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class MessageModelFactory {
    func messageToCell(_ message: Message, _ messageType: MessageTableViewCell.MessageType) -> MessageCellModel {
        var messageModel = MessageCellModel(text: message.content,
                                        time: message.created,
                                        type: .input)
        switch messageType {
        case .input:
            var senderName = message.senderName
            if containtsOnlyOfWhitespaces(string: message.senderName) {
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
