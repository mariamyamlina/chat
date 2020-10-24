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
    static var channels: [Channel] = []
    static var messages: [Int: [Message]] = [:]
    static var docId: [String] = []
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeRequest() {
        coreDataStack.performSave { context in
            let channels = ChatRequest.channels
            var channels_db: [Channel_db] = []
            var channelIndex = 0
            channels.forEach {
                let channel_db = Channel_db(identifier: $0.identifier,
                                            name: $0.name,
                                            lastMessage: $0.lastMessage,
                                            lastActivity: $0.lastActivity,
                                            in: context)
                channels_db.append(channel_db)
                
                let messagesArray = ChatRequest.messages
                let messages = messagesArray[channelIndex]
                var messages_db: [Message_db] = []
                if (messages?.count ?? -1) > 0 {
                    messages?.forEach {
                        messages_db.append(Message_db(content: $0.content,
                                                      created: $0.created,
                                                      senderId: $0.senderId,
                                                      senderName: $0.senderName,
                                                      in: context))
                    }
                    messages_db.forEach {
                        channels_db[channelIndex].addToMessages($0)
                    }
                }
                channelIndex += 1
            }
        }
    }
}
