//
//  DataService.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol DataServiceProtocol: class {
    var gcdDataManager: DataManagerProtocol { get }
    var operationDataManager: DataManagerProtocol { get }
    func save(dataManager: DataManagerProtocol, completion: @escaping (Bool) -> Void)
    func load(dataManager: DataManagerProtocol, mustReadBio: Bool, completion: @escaping () -> Void)
}

class DataService {
    let gcdDataManager: DataManagerProtocol
    let operationDataManager: DataManagerProtocol

    // MARK: - Init / deinit
    init(gcdDataManager: DataManagerProtocol, operationDataManager: DataManagerProtocol) {
        self.gcdDataManager = gcdDataManager
        self.operationDataManager = operationDataManager
    }
}

// MARK: - DataServiceProtocol
extension DataService: DataServiceProtocol {
    func save(dataManager: DataManagerProtocol, completion: @escaping (Bool) -> Void) {
        dataManager.save(completion: completion)
    }
    
    func load(dataManager: DataManagerProtocol, mustReadBio: Bool, completion: @escaping () -> Void) {
        dataManager.load(mustReadBio: mustReadBio, completion: completion)
    }
}
