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
    weak var channelsViewController: ConversationsListViewController?
    weak var messagesViewController: ConversationViewController?
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var uuid: String = ""
    
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
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            var name = ""
            var message = ""
            var activity = Date()
                            
            for document in querySnapshot!.documents {
                let docData = document.data()
                guard let nameFromFB = docData["name"] as? String else { continue }
                name = nameFromFB
                message = docData["lastMessage"] as? String ?? ""
                let lastActivityDate = (docData["lastActivity"] as? Timestamp)?.dateValue()
                activity = lastActivityDate ?? Date(timeInterval: -50000000000, since: Date())

                self.channelsViewController?.channels.append(Channel(
                    identifier: document.documentID,
                    name: name,
                    lastMessage: message,
                    lastActivity: activity))
            }
            self.sortChannels()
            DispatchQueue.main.async {
                self.channelsViewController?.tableView.reloadData()
            }
        }
    }
    
    func sortChannels() {
        channelsViewController?.channels.sort {
            if ($1.lastActivity ?? Date(timeInterval: -50000000000, since: Date())) < ($0.lastActivity ?? Date(timeInterval: -50000000000, since: Date())) {
                return true
            } else if $0.lastMessage != nil && $1.lastMessage == nil {
                return true
            } else {
                return false
            }
        }
    }

    func createChannel(_ name: String) {
        let channel = ["name": name] as [String: Any]
        reference.addDocument(data: channel)
        channelsViewController?.channels.removeAll()
        getChannels()
    }

    // MARK: - Messages

    func getMessages() {
        guard let id = messagesViewController?.docId else { return }
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            var message = ""
            var time = Date()
            var senderId = ""
            var senderName = ""
                    
            for document in querySnapshot!.documents {
                let docData = document.data()
                guard let contentFromFB = docData["content"] as? String,
                    let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                    let senderIdFromFB = docData["senderId"] as? String,
                    let senderNameFromFB = docData["senderName"] as? String else { continue }
                message = contentFromFB
                time = dateFromFB
                senderId = senderIdFromFB
                senderName = senderNameFromFB

                self.messagesViewController?.messages.append(Message(
                    content: message,
                    created: time,
                    senderId: senderId,
                    senderName: senderName))
            }
            self.sortMessages()
            DispatchQueue.main.async {
                if !(self.messagesViewController?.messages.isEmpty ?? false) {
                    self.messagesViewController?.noMessagesLabel.isHidden = true
                }
                self.messagesViewController?.tableView.reloadData()
            }
        }
    }
        
    func sortMessages() {
        messagesViewController?.messages.sort {
            if $1.created > $0.created {
                return true
            } else {
                return false
            }
        }
    }
        
    func createMessage(_ text: String) {
        let uuid = universallyUniqueIdentifier
        guard let id = messagesViewController?.docId else { return }
        let name = ProfileViewController.name ?? "Marina Dudarenko"
        let message = ["content": text, "created": Timestamp(date: Date()), "senderId": universallyUniqueIdentifier, "senderName": name] as [String: Any]
        messagesViewController?.messages.append(Message(content: text,
                                    created: Date(),
                                    senderId: uuid,
                                    senderName: name))
        reference.document(id).collection("messages").addDocument(data: message)
        if (messagesViewController?.lastRowIndex ?? -1) >= 0 {
            messagesViewController?.tableView.beginUpdates()
               messagesViewController?.tableView.insertRows(at: [IndexPath(row: messagesViewController?.lastRowIndex ?? 0, section: 0)], with: .right)
            messagesViewController?.tableView.endUpdates()
        } else {
            messagesViewController?.tableView.reloadSections([0], with: .fade)
        }
    }
}
