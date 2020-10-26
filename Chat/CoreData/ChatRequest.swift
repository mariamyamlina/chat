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
    
    func makeChannelsRequest() {
        coreDataStack.performSave { context in
            let channels = ConversationsListViewController.channels
            var channelsDB: [ChannelDB] = []
            channels.forEach {
                channelsDB.append(ChannelDB(identifier: $0.identifier,
                                            name: $0.name,
                                            lastMessage: $0.lastMessage,
                                            lastActivity: $0.lastActivity,
                                            in: context))
            }
        }
    }
    
    func makeMessagesRequest(channelId: String) {
        coreDataStack.performSave { context in
            let messages = ConversationViewController.messages
            var messagesDB: [MessageDB] = []
            if messages.count > 0 {
                messages.forEach {
                    messagesDB.append(MessageDB(identifier: $0.identifier,
                                                content: $0.content,
                                                created: $0.created,
                                                senderId: $0.senderId,
                                                senderName: $0.senderName,
                                                in: context))
                }

                let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", channelId)
                request.predicate = predicate
                
                do {
                    let channel = try context.fetch(request)
                    messagesDB.forEach {
                        channel.first?.addToMessages($0)
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
