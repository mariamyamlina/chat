//
//  FetchService.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

protocol FetchServiceProtocol {
    var channel: Channel? { get }
    var channelsFetchedResultsController: NSFetchedResultsController<ChannelDB> { get }
    var messagesFetchedResultsController: NSFetchedResultsController<MessageDB> { get }
}

class FetchService: FetchServiceProtocol {
    let channel: Channel?
    
    init(channel: Channel? = nil) {
        self.channel = channel
    }
    
    lazy var channelsFetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest = NSFetchRequest<ChannelDB>()
        fetchRequest.entity = ChannelDB.entity()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.shared.mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: "Channels")
    }()
    
    lazy var messagesFetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let channelId = channel?.identifier ?? ""
        let fetchRequest = NSFetchRequest<MessageDB>()
        fetchRequest.entity = MessageDB.entity()
        let predicate = NSPredicate(format: "channel.identifier = %@", channelId)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.shared.mainContext,
                                          sectionNameKeyPath: "formattedDate",
                                          cacheName: "Messages in channel with id \(channelId)")
    }()
}
