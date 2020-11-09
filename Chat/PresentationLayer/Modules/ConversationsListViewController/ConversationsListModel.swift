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
    let firebaseService: FirebaseServiceProtocol
    let fetchService: FetchServiceProtocol
    let dataService: DataServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol, fetchService: FetchServiceProtocol, dataService: DataServiceProtocol) {
        self.firebaseService = firebaseService
        self.fetchService = fetchService
        self.dataService = dataService
    }
    
    func getChannels(errorHandler: @escaping (String?, String?) -> Void) {
        firebaseService.getChannels(errorHandler: errorHandler)
    }
    
    func createChannel(withName name: String) {
        firebaseService.create(channel: name)
    }
    
    func deleteChannel(withId id: String) {
        firebaseService.delete(channel: id)
    }
    
    func removeListener() {
        firebaseService.removeChannelsListener()
    }
    
    func fetchChannels() -> NSFetchedResultsController<ChannelDB> {
        return fetchService.channelsFetchedResultsController
    }
    // TODO: - DRY
    func loadWithGCD(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.gcdDataManager, mustReadBio: false, completion: completion)
    }
    
    func loadWithOperations(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.operationDataManager, mustReadBio: false, completion: completion)
    }
}
