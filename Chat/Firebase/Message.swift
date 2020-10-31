//
//  Message.swift
//  Chat
//
//  Created by Maria Myamlina on 17.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init(identifier: String,
         content: String,
         created: Date,
         senderId: String,
         senderName: String) {
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init(from entity: MessageDB) {
        self.identifier = entity.identifier
        self.content = entity.content
        self.created = entity.created
        self.senderId = entity.senderId
        self.senderName = entity.senderName
    }
}
