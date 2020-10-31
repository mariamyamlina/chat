//
//  Channel.swift
//  Chat
//
//  Created by Maria Myamlina on 21.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init(identifier: String,
         name: String,
         lastMessage: String?,
         lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    init(from entity: ChannelDB) {
        self.identifier = entity.identifier
        self.name = entity.name
        self.lastMessage = entity.lastMessage
        self.lastActivity = entity.lastActivity
    }
}
