//
//  SettingsService.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol SettingsServiceProtocol {
    var currentTheme: Theme { get }
    var name: String? { get }
    var bio: String? { get }
    var image: UIImage? { get }
    func changeName(for name: String?)
    func changeBio(for bio: String?)
    func changeImage(for image: UIImage?)
}

class SettingsService {
    // MARK: - Dependencies
    let settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
}

// MARK: - SettingsServiceProtocol
extension SettingsService: SettingsServiceProtocol {
    var currentTheme: Theme {
        return settingsStorage.currentTheme
    }
    var name: String? { settingsStorage.name }
    var bio: String? { settingsStorage.bio }
    var image: UIImage? { settingsStorage.image }
    
    func changeName(for name: String?) {
        settingsStorage.changeName(for: name)
    }
    
    func changeBio(for bio: String?) {
        settingsStorage.changeBio(for: bio)
    }
    
    func changeImage(for image: UIImage?) {
        settingsStorage.changeImage(for: image)
    }
}
