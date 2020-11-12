//
//  SettingsStorage.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ISettingsStorage {
    var currentTheme: Theme { get }
    var name: String? { get set }
    var bio: String? { get set }
    var image: UIImage? { get set }
    func changeName(for name: String?)
    func changeBio(for bio: String?)
    func changeImage(for image: UIImage?)
}

class SettingsStorage: ISettingsStorage {
    // MARK: - Dependencies
    private let themeStorage: IThemeStorage

    // MARK: - Init / deinit
    init(themeStorage: IThemeStorage) {
        self.themeStorage = themeStorage
    }
    
    // MARK: - ISettingsStorage
    var currentTheme: Theme {
        let theme = Theme(rawValue: themeStorage.load()) ?? .classic
        return theme
    }
    var name: String?
    var bio: String?
    var image: UIImage?
    
    func changeName(for name: String?) {
        self.name = name
    }
    
    func changeBio(for bio: String?) {
        self.bio = bio
    }
    
    func changeImage(for image: UIImage?) {
        self.image = image
    }
}
