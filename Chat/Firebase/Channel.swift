//
//  Channel.swift
//  Chat
//
//  Created by Maria Myamlina on 21.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Channel: Equatable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.lastMessage == rhs.lastMessage && lhs.lastActivity == rhs.lastActivity
    }
}
