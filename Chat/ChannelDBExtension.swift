//
//  ChannelDBExtension.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

extension ChannelDB {
    convenience init(identifier: String,
                     name: String,
                     lastMessage: String?,
                     lastActivity: Date?,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    var about: String {
        let description = "Channel's '\(name)' info. \n"
        let count = self.messages?.allObjects.count ?? 0
        var messageCount: String = ""
        switch count {
        case 0:
            messageCount = "This channel is still empty. \n"
        case 1:
            messageCount = "This channel has \(count) message. \n"
        default:
            messageCount = "This channel has \(count) messages. \n"
        }
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageDB }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""

        return description + messageCount + messages
    }
}
