//
//  Channel.swift
//  Chat
//
//  Created by Maria Myamlina on 21.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Channel: IModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let profileImage: UIImage?
    
    init(identifier: String,
         name: String,
         lastMessage: String?,
         lastActivity: Date?,
         profileImage: UIImage?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.profileImage = profileImage
    }
    
    init(from entity: ChannelDB) {
        self.identifier = entity.identifier
        self.name = entity.name
        self.lastMessage = entity.lastMessage
        self.lastActivity = entity.lastActivity
        self.profileImage = UIImage(data: entity.profileImage ?? Data())
    }
    
    init(from dictionary: [String: Any]) {
        self.identifier = dictionary["identifier"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.lastMessage = dictionary["lastMessage"] as? String ?? nil
        self.lastActivity = dictionary["lastActivity"] as? Date ?? nil
        self.profileImage = dictionary["profileImage"] as? UIImage ?? nil
    }
}
