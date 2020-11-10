//
//  FirebaseManager.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseManagerProtocol: class {
    var universallyUniqueIdentifier: String { get }
    
    func getChannels(completion: @escaping ([Channel]) -> Void, errorHandler: @escaping (String?, String?) -> Void)
    func addChannelsListener(completion: @escaping (DocumentChangeType, Channel) -> Void, errorHandler: @escaping (String?, String?) -> Void)
    func removeChannelsListener()
    func create(channel name: String)
    func delete(channel id: String)
    
    func getMessages(in channel: Channel, completion: @escaping ([Message]) -> Void, errorHandler: @escaping (String?, String?) -> Void)
    func addMessagesListener(in channel: Channel, completion: @escaping (DocumentChangeType, Message) -> Void, errorHandler: @escaping (String?, String?) -> Void)
    func removeMessagesListener()
    func create(message text: String, in channel: Channel)
}

class FirebaseManager {
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    var channelsListener: ListenerRegistration?
    var messagesListener: ListenerRegistration?
    
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
        
    func getChannels(completion: @escaping ([Channel]) -> Void, errorHandler: @escaping (String?, String?) -> Void) {
        var channels: [Channel] = []
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                let docData = document.data()
                let docId = document.documentID
                guard let nameFromFB = docData["name"] as? String,
                    !nameFromFB.containtsOnlyOfWhitespaces() else { continue }
                let lastMessageFromFB = docData["lastMessage"] as? String
                let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                let channel = Channel(identifier: docId,
                                      name: nameFromFB,
                                      lastMessage: lastMessageFromFB,
                                      lastActivity: lastActivityFromFB)
                channels.append(channel)
            }
            // TODO
            completion(channels)
        }
    }
    
    func addChannelsListener(completion: @escaping (DocumentChangeType, Channel) -> Void, errorHandler: @escaping (String?, String?) -> Void) {
        channelsListener = reference.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                let docData = diff.document.data()
                let docId = diff.document.documentID
                if let nameFromFB = docData["name"] as? String,
                    !nameFromFB.containtsOnlyOfWhitespaces() {
                   let lastMessageFromFB = docData["lastMessage"] as? String
                   let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                    let channel = Channel(identifier: docId,
                                          name: nameFromFB,
                                          lastMessage: lastMessageFromFB,
                                          lastActivity: lastActivityFromFB)
                    completion(diff.type, channel)
                }
            }
        }
    }
    
    func removeChannelsListener() {
        channelsListener?.remove()
    }

    func create(channel name: String) {
        let channel = ["name": name] as [String: Any]
        reference.addDocument(data: channel)
    }
    
    func delete(channel id: String) {
        reference.document(id).delete()
    }

    // MARK: - Messages

    func getMessages(in channel: Channel, completion: @escaping ([Message]) -> Void, errorHandler: @escaping (String?, String?) -> Void) {
        var messages: [Message] = []
        let id = channel.identifier
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
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
            completion(messages)
        }
    }
    
    func addMessagesListener(in channel: Channel, completion: @escaping (DocumentChangeType, Message) -> Void, errorHandler: @escaping (String?, String?) -> Void) {
        let id = channel.identifier
        channelsListener = reference.document(id).collection("messages").addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                let docData = diff.document.data()
                let docId = diff.document.documentID
                if let contentFromFB = docData["content"] as? String,
                   let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                   let senderIdFromFB = docData["senderId"] as? String,
                   let senderNameFromFB = docData["senderName"] as? String {
                    let message = Message(identifier: docId,
                                          content: contentFromFB,
                                          created: dateFromFB,
                                          senderId: senderIdFromFB,
                                          senderName: senderNameFromFB)
                    completion(diff.type, message)
                }
            }
        }
    }
    
    func removeMessagesListener() {
        messagesListener?.remove()
    }
        
    func create(message text: String, in channel: Channel) {
        let message = ["content": text,
                       "created": Timestamp(date: Date()),
                       "senderId": universallyUniqueIdentifier,
                       "senderName": ProfileViewController.name ?? "Marina Dudarenko"] as [String: Any]
        reference.document(channel.identifier).collection("messages").addDocument(data: message)
    }
}
