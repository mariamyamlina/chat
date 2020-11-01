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
    
    let dbManager = CoreDataManager.shared
    
    // MARK: - Singleton
    
    static var shared: FirebaseManager = {
        return FirebaseManager()
    }()
    private init() { }
    
    // MARK: - Universally Unique Identifier
    
    lazy var universallyUniqueIdentifier: String = {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        } else {
            return UUID().uuidString
        }
    }()
}

extension FirebaseManager: FirebaseManagerProtocol {
    
    // MARK: - Channels
        
    func getChannels() {
        var channels: [Channel] = []
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                let docData = document.data()
                let docId = document.documentID
                guard let nameFromFB = docData["name"] as? String,
                      !containtsOnlyOfWhitespaces(string: nameFromFB) else { continue }
                let lastMessageFromFB = docData["lastMessage"] as? String
                let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                let channel = Channel(identifier: docId,
                                      name: nameFromFB,
                                      lastMessage: lastMessageFromFB,
                                      lastActivity: lastActivityFromFB)
                channels.append(channel)
            }
            self.dbManager.save(channels: channels)
        }
    }

    func create(channel name: String) {
        let channel = ["name": name] as [String: Any]
        reference.addDocument(data: channel)
        getChannels()
    }
    
    func delete(channel id: String) {
        reference.document(id).delete()
        getChannels()
    }

    // MARK: - Messages

    func getMessages(in channel: Channel, completion: (() -> Void)? = nil) {
        var messages: [Message] = []
        let id = channel.identifier
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                let docData = document.data()
                let docId = document.documentID
                guard let contentFromFB = docData["content"] as? String,
                      let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                      let senderIdFromFB = docData["senderId"] as? String,
                      let senderNameFromFB = docData["senderName"] as? String else { continue }
                let message = Message(identifier: docId,
                                      content: contentFromFB,
                                      created: dateFromFB,
                                      senderId: senderIdFromFB,
                                      senderName: senderNameFromFB)
                messages.append(message)
            }
            self.dbManager.save(messages: messages, inChannel: channel, completion: completion)
        }
    }
        
    func create(message text: String, in channel: Channel) {
        let uuid = universallyUniqueIdentifier
        let name = ProfileViewController.name ?? "Marina Dudarenko"
        let message = ["content": text,
                       "created": Timestamp(date: Date()),
                       "senderId": uuid,
                       "senderName": name] as [String: Any]
        reference.document(channel.identifier).collection("messages").addDocument(data: message)
        getMessages(in: channel)
    }
}
