//
//  FirebaseManager.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

protocol IFirebaseManager: class {
    var universallyUniqueIdentifier: String { get }
    
    func getChannels(completion: @escaping ([[String: Any]]) -> Void,
                     errorHandler: @escaping (String?, String?) -> Void)
    func addChannelsListener(completion: @escaping (DocumentChangeType, [String: Any]) -> Void,
                             errorHandler: @escaping (String?, String?) -> Void)
    func removeChannelsListener()
    func create(channel name: String)
    func delete(channel id: String)
    
    func getMessages(inChannel id: String, completion: @escaping ([[String: Any]]) -> Void,
                     errorHandler: @escaping (String?, String?) -> Void)
    func addMessagesListener(inChannel id: String, completion: @escaping (DocumentChangeType, [String: Any]) -> Void,
                             errorHandler: @escaping (String?, String?) -> Void)
    func removeMessagesListener()
    func create(message text: String, inChannel id: String)
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
    
    // MARK: - Dependencies
    private let settingsStorage: ISettingsStorage

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
}

extension FirebaseManager: IFirebaseManager {
    // MARK: - Channels
    func getChannels(completion: @escaping ([[String: Any]]) -> Void,
                     errorHandler: @escaping (String?, String?) -> Void) {
        var channels: [[String: Any]] = []
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                guard let channel = self.getChannel(documentData: document.data(),
                                                    documentId: document.documentID) else { continue }
                channels.append(channel)
            }
            completion(channels)
        }
    }
    
    func addChannelsListener(completion: @escaping (DocumentChangeType, [String: Any]) -> Void,
                             errorHandler: @escaping (String?, String?) -> Void) {
        channelsListener = reference.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            for diff in snapshot.documentChanges {
                guard let channel = self.getChannel(documentData: diff.document.data(),
                                                    documentId: diff.document.documentID) else { continue }
                completion(diff.type, channel)
            }
        }
    }
    
    private func getChannel(documentData docData: [String: Any],
                            documentId docId: String) -> [String: Any]? {
        guard let nameFromFB = docData["name"] as? String,
            !nameFromFB.containtsOnlyOfWhitespaces() else { return nil }
        let lastMessageFromFB = docData["lastMessage"] as? String
        let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()
        let channel = ["identifier": docId,
                       "name": nameFromFB,
                       "lastMessage": lastMessageFromFB as Any,
                       "lastActivity": lastActivityFromFB as Any,
                       "profileImage": self.generateImage() as Any] as [String: Any]
        return channel
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
    func getMessages(inChannel id: String, completion: @escaping ([[String: Any]]) -> Void,
                     errorHandler: @escaping (String?, String?) -> Void) {
        var messages: [[String: Any]] = []
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                guard let message = self.getMessage(documentData: document.data(),
                                                    documentId: document.documentID) else { continue }
                messages.append(message)
            }
            completion(messages)
        }
    }
    
    func addMessagesListener(inChannel id: String, completion: @escaping (DocumentChangeType, [String: Any]) -> Void,
                             errorHandler: @escaping (String?, String?) -> Void) {
        channelsListener = reference.document(id).collection("messages").addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard error == nil else {
                errorHandler("Firebase", error?.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else { return }
            for diff in snapshot.documentChanges {
                guard let message = self.getChannel(documentData: diff.document.data(),
                                                    documentId: diff.document.documentID) else { continue }
                completion(diff.type, message)
            }
        }
    }
    
    private func getMessage(documentData docData: [String: Any],
                            documentId docId: String) -> [String: Any]? {
        guard let contentFromFB = docData["content"] as? String,
              let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
              let senderIdFromFB = docData["senderId"] as? String,
              let senderNameFromFB = docData["senderName"] as? String else { return nil }
        let message = ["identifier": docId,
                       "content": contentFromFB,
                       "created": dateFromFB,
                       "senderId": senderIdFromFB,
                       "senderName": senderNameFromFB] as [String: Any]
        return message
    }
    
    func removeMessagesListener() {
        messagesListener?.remove()
    }
        
    func create(message text: String, inChannel id: String) {
        let message = ["content": text,
                       "created": Timestamp(date: Date()),
                       "senderId": universallyUniqueIdentifier,
                       "senderName": settingsStorage.name ?? "Marina Dudarenko"] as [String: Any]
        reference.document(id).collection("messages").addDocument(data: message)
    }
}

// MARK: - Generator
extension FirebaseManager {
    private func generateImage() -> UIImage? {
        let array = ["Butters", "Chef", "Craig", "Eric", "Ike", "Jimmy", "Kenny", "Kyle",
                     "Lien", "Randy", "Sheila", "Sheron", "Stan", "Timmy", "Token", "Wendy"]
        if let name = array.randomElement() {
            return UIImage(named: name)
        } else {
            return nil
        }
    }
}
