//
//  ChannelModelFactory.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ChannelModelFactory {
    func channelToCell(_ channel: Channel, _ image: UIImage?) -> ConversationCellModel {
        return ConversationCellModel(name: channel.name,
                                     message: channel.lastMessage ?? "No messages yet",
                                     date: channel.lastActivity,
                                     image: image,
                                     isOnline: true,
                                     hasUnreadMessages: false)
    }
}
