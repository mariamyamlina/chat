//
//  DataService.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol IDataService: class {
    var gcdDataManager: IDataManager { get }
    var operationDataManager: IDataManager { get }
    func save(dataManager: IDataManager, nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
    func load(dataManager: IDataManager, mustReadBio: Bool, completion: @escaping () -> Void)
}

class DataService {
    let gcdDataManager: IDataManager
    let operationDataManager: IDataManager

    // MARK: - Init / deinit
    init(gcdDataManager: IDataManager, operationDataManager: IDataManager) {
        self.gcdDataManager = gcdDataManager
        self.operationDataManager = operationDataManager
    }
}

// MARK: - IDataService
extension DataService: IDataService {
    func save(dataManager: IDataManager, nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        dataManager.save(nameDidChange: nameDidChange,
                         bioDidChange: bioDidChange,
                         imageDidChange: imageDidChange,
                         completion: completion)
    }
    
    func load(dataManager: IDataManager, mustReadBio: Bool, completion: @escaping () -> Void) {
        dataManager.load(mustReadBio: mustReadBio,
                         completion: completion)
    }
}
