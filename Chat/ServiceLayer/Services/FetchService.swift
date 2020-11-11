//
//  FetchService.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

protocol FetchServiceProtocol {
    func getFRC<T: NSManagedObject>(entityType: EntityType,
                                    channelId: String?,
                                    sectionNameKeyPath: String?,
                                    cacheName: String?) -> NSFetchedResultsController<T>
}

class FetchService {
    let coreDataStack: CoreDataStackProtocol
    
    // MARK: - Init / deinit
    // TODO
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
}

// MARK: - FetchServiceProtocol
extension FetchService: FetchServiceProtocol {
    func getFRC<T: NSManagedObject>(entityType: EntityType,
                                    channelId: String?,
                                    sectionNameKeyPath: String?,
                                    cacheName: String?) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController(fetchRequest: coreDataStack.fetchRequest(for: entityType, channelId: channelId),
                                          managedObjectContext: CoreDataStack.shared.mainContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: cacheName)
    }
}
