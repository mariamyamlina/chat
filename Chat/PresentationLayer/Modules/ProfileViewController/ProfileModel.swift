//
//  ProfileModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ProfileModelProtocol: class {
    func saveWithGCD(nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
    func loadWithGCD(completion: @escaping () -> Void)
    func saveWithOperations(nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
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

class ProfileModel {
    // MARK: - Dependencies
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
    func saveWithGCD(nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        dataService.save(dataManager: dataService.gcdDataManager,
                         nameDidChange: nameDidChange,
                         bioDidChange: bioDidChange,
                         imageDidChange: imageDidChange,
                         completion: completion)
    }
    
    func loadWithGCD(completion: @escaping () -> Void) {
        dataService.load(dataManager: dataService.gcdDataManager, mustReadBio: true, completion: completion)
    }
    
    func saveWithOperations(nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        dataService.save(dataManager: dataService.operationDataManager,
                         nameDidChange: nameDidChange,
                         bioDidChange: bioDidChange,
                         imageDidChange: imageDidChange,
                         completion: completion)
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
