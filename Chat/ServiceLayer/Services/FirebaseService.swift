//
//  FirebaseService.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseServiceProtocol: class {
    var universallyUniqueIdentifier: String { get }
    
    func getChannels(errorHandler: @escaping (String?, String?) -> Void)
    func addChannelsListener(errorHandler: @escaping (String?, String?) -> Void)
    func removeChannelsListener()
    func create(channel name: String)
    func delete(channel id: String)
    
    func getMessages(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void, completion: (() -> Void)?)
    func addMessagesListener(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func removeMessagesListener()
    func create(message text: String, in channel: Channel)
}

class FirebaseService {
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    let dbService = CoreDataService(coreDataStack: CoreDataStack.shared)
    
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

extension FirebaseService: FirebaseServiceProtocol {
    // MARK: - Channels
        
    func getChannels(errorHandler: @escaping (String?, String?) -> Void) {
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
                      !containtsOnlyOfWhitespaces(string: nameFromFB) else { continue }
                let lastMessageFromFB = docData["lastMessage"] as? String
                let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                let channel = Channel(identifier: docId,
                                      name: nameFromFB,
                                      lastMessage: lastMessageFromFB,
                                      lastActivity: lastActivityFromFB)
                channels.append(channel)
            }
            self.dbService.save(channels: channels, errorHandler: errorHandler)
            self.addChannelsListener(errorHandler: errorHandler)
        }
    }
    
    func addChannelsListener(errorHandler: @escaping (String?, String?) -> Void) {
        channelsListener = reference.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                let docData = diff.document.data()
                let docId = diff.document.documentID
                if let nameFromFB = docData["name"] as? String, !containtsOnlyOfWhitespaces(string: nameFromFB) {
                   let lastMessageFromFB = docData["lastMessage"] as? String
                   let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
                    let channel = Channel(identifier: docId,
                                          name: nameFromFB,
                                          lastMessage: lastMessageFromFB,
                                          lastActivity: lastActivityFromFB)
                    if diff.type == .added {
                        self.dbService.save(channel: channel, errorHandler: errorHandler)
                    }
                    if diff.type == .modified {
                        self.dbService.update(channel: channel, errorHandler: errorHandler)
                    }
                    if diff.type == .removed {
                        self.dbService.delete(channel: channel, errorHandler: errorHandler)
                    }
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

    func getMessages(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void, completion: (() -> Void)? = nil) {
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
            self.dbService.save(messages: messages, inChannel: channel, errorHandler: errorHandler, completion: completion)
            self.addMessagesListener(in: channel, errorHandler: errorHandler)
        }
    }
    
    func addMessagesListener(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
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
                    if diff.type == .added {
                        self.dbService.save(message: message, inChannel: channel, errorHandler: errorHandler)
                    }
                    if diff.type == .modified { }
                    if diff.type == .removed { }
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
