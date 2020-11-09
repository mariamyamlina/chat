//
//  ProfileModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ProfileModelProtocol: class {
    // TODO
    var delegate: ProfileModelDelegate? { get set }
    func saveWithGCD(completion: @escaping (Bool) -> Void)
    func loadWithGCD(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
    func saveWithOperations(completion: @escaping (Bool) -> Void)
    func loadWithOperations(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
}

protocol ProfileModelDelegate: class {
    // TODO
}

class ProfileModel: ProfileModelProtocol {
    // TODO
    weak var delegate: ProfileModelDelegate?
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func saveWithGCD(completion: @escaping (Bool) -> Void) {
        dataService.save(dataManager: dataService.gcdDataStorage, completion: completion)
    }
    
    func loadWithGCD(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        dataService.load(dataManager: dataService.gcdDataStorage, mustReadName: mustReadName, mustReadBio: mustReadBio, mustReadImage: mustReadImage, completion: completion)
    }
    
    func saveWithOperations(completion: @escaping (Bool) -> Void) {
        dataService.save(dataManager: dataService.operationDataStorage, completion: completion)
    }
    
    func loadWithOperations(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        dataService.load(dataManager: dataService.operationDataStorage, mustReadName: mustReadName, mustReadBio: mustReadBio, mustReadImage: mustReadImage, completion: completion)
    }
}
