//
//  FetchService.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchService {
    func getFRC<T: NSManagedObject>(entityType: ModelType,
                                    channelId: String?,
                                    sectionNameKeyPath: String?,
                                    cacheName: String?) -> NSFetchedResultsController<T>
}

class FetchService {
    let coreDataStack: ICoreDataStack
    
    // MARK: - Init / deinit
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

// MARK: - IFetchService
extension FetchService: IFetchService {
    func getFRC<T: NSManagedObject>(entityType: ModelType,
                                    channelId: String?,
                                    sectionNameKeyPath: String?,
                                    cacheName: String?) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController(fetchRequest: coreDataStack.fetchRequest(for: entityType, channelId: channelId),
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: cacheName)
    }
}
