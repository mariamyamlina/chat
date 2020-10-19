//
//  FirebaseManagerProtocol.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseManagerProtocol: class {
    var channelsViewController: ConversationsListViewController? { get set }
    var messagesViewController: ConversationViewController? { get set }
    
    var db: Firestore { get }
    var reference: CollectionReference { get }
    var uuid: String { get }
    
    func getChannels()
    func createChannel(_ name: String)
    func sortChannels()
    
    func getMessages()
    func createMessage(_ text: String)
    func sortMessages()
}
