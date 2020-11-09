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

class DataService: DataServiceProtocol {
    static var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    static let nameFile = "ProfileName.txt"
    static let bioFile = "ProfileBio.txt"
    static let imageFile = "ProfileImage.jpeg"
    
    static var nameFileURL: URL = DataService.urlDir?.appendingPathComponent(DataService.nameFile) ?? URL(fileURLWithPath: "")
    static var bioFileURL: URL = DataService.urlDir?.appendingPathComponent(DataService.bioFile) ?? URL(fileURLWithPath: "")
    static var imageFileURL: URL = DataService.urlDir?.appendingPathComponent(DataService.imageFile) ?? URL(fileURLWithPath: "")
    
    let gcdDataManager: DataManagerProtocol
    let operationDataManager: DataManagerProtocol

    init(gcdDataManager: DataManagerProtocol, operationDataManager: DataManagerProtocol) {
        self.gcdDataManager = gcdDataManager
        self.operationDataManager = operationDataManager
    }
    
    func save(dataManager: DataManagerProtocol, completion: @escaping (Bool) -> Void) {
        dataManager.save(completion: completion)
    }
    
    func load(dataManager: DataManagerProtocol, mustReadBio: Bool, completion: @escaping () -> Void) {
        dataManager.load(mustReadBio: mustReadBio, completion: completion)
    }
}
