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
        channelsViewController?.channels.removeAll()
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
                            
            for document in querySnapshot!.documents {
                let docData = document.data()
                guard let nameFromFB = docData["name"] as? String,
                      !nameFromFB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                let lastMessageFromFB = docData["lastMessage"] as? String
                let lastActivityFromFB = (docData["lastActivity"] as? Timestamp)?.dateValue()

                self.channelsViewController?.channels.append(Channel(identifier: document.documentID,
                                                                     name: nameFromFB,
                                                                     lastMessage: lastMessageFromFB,
                                                                     lastActivity: lastActivityFromFB))
            }
            
            self.sortChannels()
            self.channelsViewController?.tableView.reloadData()
        }
    }
    
    func sortChannels() {
        channelsViewController?.channels.sort {
            let date = Date(timeInterval: -50000000000, since: Date())
            let firstDate = $0.lastActivity ?? date
            let secondDate = $1.lastActivity ?? date
            if secondDate < firstDate {
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
        getChannels()
    }

    // MARK: - Messages

    func getMessages() {
        guard let id = messagesViewController?.docId else { return }
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
                    
            for document in querySnapshot!.documents {
                let docData = document.data()
                guard let contentFromFB = docData["content"] as? String,
                      let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                      let senderIdFromFB = docData["senderId"] as? String,
                      let senderNameFromFB = docData["senderName"] as? String else { continue }

                self.messagesViewController?.messages.append(Message(content: contentFromFB,
                                                                     created: dateFromFB,
                                                                     senderId: senderIdFromFB,
                                                                     senderName: senderNameFromFB))
            }
            
            self.sortMessages()
            if let messagesArray = self.messagesViewController?.messages, !messagesArray.isEmpty {
                self.messagesViewController?.noMessagesLabel.isHidden = true
            }
            self.messagesViewController?.tableView.reloadData()
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
        let message = ["content": text,
                       "created": Timestamp(date: Date()),
                       "senderId": uuid,
                       "senderName": name] as [String: Any]
        reference.document(id).collection("messages").addDocument(data: message)
        messagesViewController?.messages.append(Message(content: text,
                                                        created: Date(),
                                                        senderId: uuid,
                                                        senderName: name))
        if let rowIndex = messagesViewController?.lastRowIndex {
            if rowIndex >= 0 {
                messagesViewController?.tableView.beginUpdates()
                   messagesViewController?.tableView.insertRows(at: [IndexPath(row: rowIndex + 1, section: 0)], with: .right)
                messagesViewController?.tableView.endUpdates()
            } else {
                messagesViewController?.tableView.reloadSections([0], with: .fade)
            }
        }
    }
}
