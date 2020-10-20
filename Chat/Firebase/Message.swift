//
//  Message.swift
//  Chat
//
//  Created by Maria Myamlina on 17.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    var jsonType: [String: Any] {
        let json = ["content": content,
                    "created": Timestamp(date: created),
                    "senderId": senderId,
                    "senderName": senderName] as [String: Any]
        return json
    }
}
