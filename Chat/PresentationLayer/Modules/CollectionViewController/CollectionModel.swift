//
//  CollectionModel.swift
//  Chat
//
//  Created by Maria Myamlina on 13.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ICollectionModel: class {
    var currentTheme: Theme { get }
}

class CollectionModel {
    // MARK: - Dependencies
    var settingsService: ISettingsService
    
    // MARK: - Init / deinir
    init(settingsService: ISettingsService) {
        self.settingsService = settingsService
    }
}

// MARK: - ICollectionModel
extension CollectionModel: ICollectionModel {
    var currentTheme: Theme { return settingsService.currentTheme }
}
