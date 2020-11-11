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
    var currentTheme: Theme { get }
    var name: String? { get }
    var bio: String? { get }
    var image: UIImage? { get }
    func changeName(for name: String?)
    func changeBio(for bio: String?)
    func changeImage(for image: UIImage?)
}

protocol ProfileModelDelegate: class {
    // TODO
}

class ProfileModel {
    // TODO
    // MARK: - Dependencies
    weak var delegate: ProfileModelDelegate?
    let dataService: DataServiceProtocol
    let loger: LogerProtocol
    var settingsService: SettingsServiceProtocol
    
    // MARK: - Init / deinit
    init(dataService: DataServiceProtocol, loger: LogerProtocol, settingsService: SettingsServiceProtocol) {
        self.dataService = dataService
        self.loger = loger
        self.settingsService = settingsService
    }
}

// MARK: - ProfileModelProtocol
extension ProfileModel: ProfileModelProtocol {    
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
    
    var currentTheme: Theme {
        return settingsService.currentTheme
    }
    
    var name: String? {
        return settingsService.name
    }
    
    var bio: String? {
        return settingsService.bio
    }
    
    var image: UIImage? {
        return settingsService.image
    }
    
    func changeName(for name: String?) {
        settingsService.changeName(for: name)
    }
    
    func changeBio(for bio: String?) {
        settingsService.changeBio(for: bio)
    }
    
    func changeImage(for image: UIImage?) {
        settingsService.changeImage(for: image)
    }
}
