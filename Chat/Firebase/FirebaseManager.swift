//
//  FirebaseManager.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager {
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    // MARK: - Universally Unique Identifier
    
    lazy var universallyUniqueIdentifier: String = {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        } else {
            return UUID().uuidString
        }
    }()
    
    var coreDataStack = CoreDataStack()
    
    func getInfoAndWriteToCoreData() {
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                let docData = document.data()
                guard let nameFromFB = docData["name"] as? String,
                      !nameFromFB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                let lastMessageFromFB = docData["lastMessage"] as? String
                let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                let id = document.documentID
                ChatRequest.docId.append(id)
                let channel = Channel(identifier: id,
                                      name: nameFromFB,
                                      lastMessage: lastMessageFromFB,
                                      lastActivity: lastActivityFromFB)
                ChatRequest.channels.append(channel)
            }

            let group = DispatchGroup()
            for i in 0...ChatRequest.channels.count - 1 {
                group.enter()
                var messages: [Message] = []
                self.reference.document(ChatRequest.docId[i]).collection("messages").getDocuments { (querySnapshot, error) in
                    guard error == nil else { return }
                    guard let snapshot = querySnapshot else { return }
                    for document in snapshot.documents {
                        let docData = document.data()
                        guard let contentFromFB = docData["content"] as? String,
                              let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                              let senderIdFromFB = docData["senderId"] as? String,
                              let senderNameFromFB = docData["senderName"] as? String else { continue }
                        let message = Message(content: contentFromFB,
                                              created: dateFromFB,
                                              senderId: senderIdFromFB,
                                              senderName: senderNameFromFB)
                        messages.append(message)
                    }
                    ChatRequest.messages[i] = messages
                    group.leave()
                    
                }
            }
            group.notify(queue: .main) {
                self.coreDataStack.didUpdateDataBase = { stack in
                    stack.printDatabaseStatistics()
                }
                self.coreDataStack.enableObservers()
                let chatRequest = ChatRequest(coreDataStack: self.coreDataStack)
                chatRequest.makeRequest()
            }
        }
    }
}

extension FirebaseManager: FirebaseManagerProtocol {
    // MARK: - Channels
        
    func getChannels(completion: @escaping () -> Void) {
        ConversationsListViewController.channels.removeAll()
        ConversationsListViewController.images.removeAll()
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                let docData = document.data()
                guard let nameFromFB = docData["name"] as? String,
                      !nameFromFB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                let lastMessageFromFB = docData["lastMessage"] as? String
                let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                let channel = Channel(identifier: document.documentID,
                                      name: nameFromFB,
                                      lastMessage: lastMessageFromFB,
                                      lastActivity: lastActivityFromFB)
                ConversationsListViewController.channels.append(channel)
                ConversationsListViewController.images.append(generateImage())
            }
            completion()
        }
    }

    func createChannel(_ name: String, completion: @escaping () -> Void) {
        let channel = ["name": name] as [String: Any]
        reference.addDocument(data: channel)
        getChannels(completion: completion)
    }

    // MARK: - Messages

    func getMessages(completion: @escaping () -> Void) {
        ConversationViewController.messages.removeAll()
        guard let id = ConversationViewController.docId else { return }
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                let docData = document.data()
                guard let contentFromFB = docData["content"] as? String,
                      let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                      let senderIdFromFB = docData["senderId"] as? String,
                      let senderNameFromFB = docData["senderName"] as? String else { continue }
                let message = Message(content: contentFromFB,
                                      created: dateFromFB,
                                      senderId: senderIdFromFB,
                                      senderName: senderNameFromFB)
                ConversationViewController.messages.append(message)
            }
            completion()
        }
    }
        
    func createMessage(_ text: String, completion: @escaping () -> Void) {
        let uuid = universallyUniqueIdentifier
        guard let id = ConversationViewController.docId else { return }
        let name = ProfileViewController.name ?? "Marina Dudarenko"
        let message = Message(content: text,
                              created: Date(),
                              senderId: uuid,
                              senderName: name)
        reference.document(id).collection("messages").addDocument(data: message.jsonType)
        ConversationViewController.messages.append(message)
        completion()
    }
}
