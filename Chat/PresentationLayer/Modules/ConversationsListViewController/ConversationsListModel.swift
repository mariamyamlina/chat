//
//  ConversationsListModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import CoreData

// MARK: - ConversationCellModel
struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date?
    let image: UIImage?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

// MARK: - ChannelModelFactory
class ChannelModelFactory {
    func channelToCell(_ channel: Channel) -> ConversationCellModel {
        return ConversationCellModel(name: channel.name,
                                     message: channel.lastMessage ?? "No messages yet",
                                     date: channel.lastActivity,
                                     image: channel.profileImage,
                                     isOnline: true,
                                     hasUnreadMessages: false)
    }
}

// MARK: - ConversationsListModel
protocol ConversationsListModelProtocol: class {
    func getChannels(errorHandler: @escaping (String?, String?) -> Void)
    func createChannel(withName name: String)
    func deleteChannel(at indexPath: IndexPath)
    func removeListener()
    var frc: NSFetchedResultsController<ChannelDB> { get }
    func loadWithGCD(completion: @escaping () -> Void)
    func loadWithOperations(completion: @escaping () -> Void)
    var currentTheme: Theme { get }
    var name: String? { get }
    var image: UIImage? { get }
    func channel(at indexPath: IndexPath) -> Channel
    func channelModel(at indexPath: IndexPath) -> ConversationCellModel
}

class ConversationsListModel {
    // MARK: - Dependencies
    let channelService: ChannelServiceProtocol
    let dataService: DataServiceProtocol
    var settingsService: SettingsServiceProtocol
    var fetchService: FetchServiceProtocol
    
    // MARK: - Init / deinit
    init(channelService: ChannelServiceProtocol, dataService: DataServiceProtocol, settingsService: SettingsServiceProtocol, fetchService: FetchServiceProtocol) {
        self.channelService = channelService
        self.dataService = dataService
        self.settingsService = settingsService
        self.fetchService = fetchService
    }
    
    lazy var frc: NSFetchedResultsController<ChannelDB> = {
        return fetchService.getFRC(entityType: .channel, channelId: nil, sectionNameKeyPath: nil, cacheName: "Channels")
    }()
}

// MARK: - ConversationsListModelProtocol
extension ConversationsListModel: ConversationsListModelProtocol {
    func getChannels(errorHandler: @escaping (String?, String?) -> Void) {
        channelService.getChannels(errorHandler: errorHandler)
    }
    
    func createChannel(withName name: String) {
        channelService.create(channel: name)
    }

    func deleteChannel(at indexPath: IndexPath) {
        channelService.delete(channel: channel(at: indexPath).identifier)
    }
    
    func removeListener() {
        channelService.removeListener()
    }
    
    func loadWithGCD(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.gcdDataManager, mustReadBio: false, completion: completion)
    }
    
    func loadWithOperations(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.operationDataManager, mustReadBio: false, completion: completion)
    }
    
    var currentTheme: Theme {
        return settingsService.currentTheme
    }
    
    var name: String? {
        return settingsService.name
    }
    
    var image: UIImage? {
        return settingsService.image
    }
    
    func channel(at indexPath: IndexPath) -> Channel {
        let channelDB = frc.object(at: indexPath)
        return Channel(from: channelDB)
    }
    
    func channelModel(at indexPath: IndexPath) -> ConversationCellModel {
        let channelCellFactory = ChannelModelFactory()
        return channelCellFactory.channelToCell(channel(at: indexPath))
    }
}
