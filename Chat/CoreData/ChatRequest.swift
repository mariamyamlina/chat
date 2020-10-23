//
//  ChatRequest.swift
//  Chat
//
//  Created by Maria Myamlina on 23.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

struct ChatRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeRequest() {
        coreDataStack.performSave { context in
            let message1 = Message_db(content: "First",
                                   created: Date(),
                                   senderId: "ID1",
                                   senderName: "Name1",
                                   in: context)
            let message2 = Message_db(content: "Second",
                                   created: Date(),
                                   senderId: "ID2",
                                   senderName: "Name2",
                                   in: context)
            let message3 = Message_db(content: "Third",
                                   created: Date(),
                                   senderId: "ID1",
                                   senderName: "Name1",
                                   in: context)
            let message4 = Message_db(content: "Fourth",
                                   created: Date(),
                                   senderId: "ID2",
                                   senderName: "Name2",
                                   in: context)
            
            let john = Channel_db(identifier: "ID1",
                                  name: "John",
                                  lastMessage: nil,
                                  lastActivity: nil,
                                  in: context)
            [message1, message3].forEach { john.addToMessages($0) }
            
            let alex = Channel_db(identifier: "ID2",
                                  name: "Alex",
                                  lastMessage: nil,
                                  lastActivity: nil,
                                  in: context)
            [message2, message4].forEach { alex.addToMessages($0) }
        }
    }
}
