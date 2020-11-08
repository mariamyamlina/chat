//
//  ConversationModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
// TODO: - Убрать CoreData отсюда
import CoreData

struct MessageCellModel {
    let text: String
    let time: Date
    let type: MessageTableViewCell.MessageType
}

protocol ConversationModelProtocol: class {
    // TODO: - Разобраться с делегатом дважды
    var delegate: ConversationModelDelegate? { get set }
    var channel: Channel? { get }
    func universallyUniqueIdentifier() -> String
    func getMessages(inChannel channel: Channel, errorHandler: @escaping (String?, String?) -> Void, completion: (() -> Void)?)
    func createMessage(withText text: String, inChannel channel: Channel)
    func removeListener()
//    func setupFetchedController()
    func fetchMessages() -> NSFetchedResultsController<MessageDB>?
}

protocol ConversationModelDelegate: class {
    func setup(dataSource: [MessageCellModel])
    // TODO: - Разобраться с этой функцией дважды
    func show(error message: String)
}

class ConversationModel: ConversationModelProtocol {
    weak var delegate: ConversationModelDelegate?
    var channel: Channel?
    let firebaseService: FirebaseServiceProtocol
    let fetchService: FetchServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol, fetchService: FetchServiceProtocol, channel: Channel?) {
        self.firebaseService = firebaseService
        self.fetchService = fetchService
        self.channel = channel
    }
    
    func universallyUniqueIdentifier() -> String {
        return firebaseService.universallyUniqueIdentifier
    }
    
    func getMessages(inChannel channel: Channel, errorHandler: @escaping (String?, String?) -> Void, completion: (() -> Void)?) {
        firebaseService.getMessages(in: channel, errorHandler: errorHandler, completion: completion)
    }
    
    func createMessage(withText text: String, inChannel channel: Channel) {
        firebaseService.create(message: text, in: channel)
    }
    
    func removeListener() {
        firebaseService.removeMessagesListener()
    }
    
//    func setupFetchedController() {
//        return fetchService.setupMessagesFetchedResultsController(with: channel)
//    }
    
    func fetchMessages() -> NSFetchedResultsController<MessageDB>? {
        return fetchService.messagesFetchedResultsController
    }
}
