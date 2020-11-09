//
//  ProfileModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ProfileModelProtocol: class {
    // TODO
    var delegate: ProfileModelDelegate? { get set }
    func saveWithGCD(completion: @escaping (Bool) -> Void)
    func loadWithGCD(completion: @escaping () -> Void)
    func saveWithOperations(completion: @escaping (Bool) -> Void)
    func loadWithOperations(completion: @escaping () -> Void)
    func buttonLog(_ button: UIButton, _ function: String)
}

protocol ProfileModelDelegate: class {
    // TODO
}

class ProfileModel: ProfileModelProtocol {
    // TODO
    weak var delegate: ProfileModelDelegate?
    let dataService: DataServiceProtocol
    let loger: LogerProtocol
    
    init(dataService: DataServiceProtocol, loger: LogerProtocol) {
        self.dataService = dataService
        self.loger = loger
    }
    
    func saveWithGCD(completion: @escaping (Bool) -> Void) {
        dataService.save(dataManager: dataService.gcdDataManager, completion: completion)
    }
    
    func loadWithGCD(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.gcdDataManager, mustReadBio: true, completion: completion)
    }
    
    func saveWithOperations(completion: @escaping (Bool) -> Void) {
        dataService.save(dataManager: dataService.operationDataManager, completion: completion)
    }
    
    func loadWithOperations(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.operationDataManager, mustReadBio: true, completion: completion)
    }
    
    func buttonLog(_ button: UIButton, _ function: String) {
        loger.printButtonLog(button, function)
    }
}
