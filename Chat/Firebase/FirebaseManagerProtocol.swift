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
    var db: Firestore { get }
    var reference: CollectionReference { get }
    var universallyUniqueIdentifier: String { get }
    
    func getChannels(source: () -> Void, completion: @escaping () -> Void)
    func createChannel(_ name: String, source: () -> Void, completion: @escaping () -> Void)
    
    func getMessages(completion: @escaping () -> Void)
    func createMessage(_ text: String, completion: @escaping () -> Void)
}
