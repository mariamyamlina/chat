//
//  MessageDBExtension.swift
//  Chat
//
//  Created by Maria Myamlina on 25.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

extension MessageDB {
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
        let text = content.replacingOccurrences(of: "\n", with: "\n\t\t\t\t\t" + " ")
        return "message: '\(text)'"
    }
}
