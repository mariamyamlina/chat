//
//  ObjectsExtensions.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
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
        let description = "\(String(describing: name)) \n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? Message_db }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""

        return description + messages
    }
}

extension Message_db {
    convenience init(content: String,
                     created: Date,
                     senderId: String,
                     senderName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    var about: String {
        return "Message: \(String(describing: content))"
    }
}
