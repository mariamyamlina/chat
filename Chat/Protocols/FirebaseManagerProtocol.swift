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
