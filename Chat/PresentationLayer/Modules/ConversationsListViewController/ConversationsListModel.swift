//
//  ConversationsListModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
// TODO: - Убрать CoreData отсюда
import CoreData

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date?
    let image: UIImage?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

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

protocol ConversationsListModelProtocol: class {
    var delegate: ConversationsListModelDelegate? { get set }
    func getChannels(errorHandler: @escaping (String?, String?) -> Void)
    func createChannel(withName name: String)
    func deleteChannel(withId id: String)
    func removeListener()
    func fetchChannels() -> NSFetchedResultsController<ChannelDB>
    func loadWithGCD(completion: @escaping () -> Void)
    func loadWithOperations(completion: @escaping () -> Void)
}

protocol ConversationsListModelDelegate: class {
    func setup(dataSource: [ConversationCellModel])
    func show(error message: String)
}

class ConversationsListModel: ConversationsListModelProtocol {
    weak var delegate: ConversationsListModelDelegate?
    let channelService: ChannelServiceProtocol
    let dataService: DataServiceProtocol
    
    init(channelService: ChannelServiceProtocol, dataService: DataServiceProtocol) {
        self.channelService = channelService
        self.dataService = dataService
    }
    
    func getChannels(errorHandler: @escaping (String?, String?) -> Void) {
        channelService.getChannels(errorHandler: errorHandler)
    }
    
    func createChannel(withName name: String) {
        channelService.create(channel: name)
    }
    
    func deleteChannel(withId id: String) {
        channelService.delete(channel: id)
    }
    
    func removeListener() {
        channelService.removeChannelsListener()
    }
    
    func fetchChannels() -> NSFetchedResultsController<ChannelDB> {
        return channelService.channelsFetchedResultsController
    }
    // TODO: - DRY
    func loadWithGCD(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.gcdDataManager, mustReadBio: false, completion: completion)
    }
    
    func loadWithOperations(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.operationDataManager, mustReadBio: false, completion: completion)
    }
}
