//
//  FirebaseManager.swift
//  Chat
//
//  Created by Maria Myamlina on 18.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Universally Unique Identifier

func getUniversallyUniqueIdentifier() -> String {
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    } else {
        return UUID().uuidString
    }
}

class FirebaseManager {
    weak var channelsViewController: ConversationsListViewController?
    weak var messagesViewController: ConversationViewController?
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var uuid: String = ""

    init() {
//        channelsViewController?.delegate = self
//        messagesViewController?.delegate = self
    }
}

//extension FirebaseManager: FirebaseManagerDelegate {
//    
//    // MARK: - Channels
//
//    
//}
