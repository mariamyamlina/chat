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
            var channelsDB: [ChannelDB] = []
            var channelIndex = 0
            channels.forEach {
                let channelDB = ChannelDB(identifier: $0.identifier,
                                            name: $0.name,
                                            lastMessage: $0.lastMessage,
                                            lastActivity: $0.lastActivity,
                                            in: context)
                channelsDB.append(channelDB)
                
                let messagesArray = ChatRequest.messages
                let messages = messagesArray[channelIndex]
                var messagesDB: [MessageDB] = []
                if (messages?.count ?? -1) > 0 {
                    messages?.forEach {
                        messagesDB.append(MessageDB(content: $0.content,
                                                      created: $0.created,
                                                      senderId: $0.senderId,
                                                      senderName: $0.senderName,
                                                      in: context))
                    }
                    messagesDB.forEach {
                        channelsDB[channelIndex].addToMessages($0)
                    }
                }
                channelIndex += 1
            }
        }
        ChatRequest.channels = []
        ChatRequest.messages = [:]
        ChatRequest.docId = []
    }
}
