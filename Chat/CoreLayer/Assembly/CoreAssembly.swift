//
//  CoreAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var gcdDataManager: DataManagerProtocol { get }
    var operationDataManager: DataManagerProtocol { get }
    // TODO
    var coreDataStack: CoreDataStackProtocol { get }
    var firebaseManager: FirebaseManagerProtocol { get }
    var themeStorage: ThemeStorageProtocol { get }
    var settingsStorage: SettingsStorageProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var gcdDataManager: DataManagerProtocol = GCDDataManager(settingsStorage: self.settingsStorage)
    lazy var operationDataManager: DataManagerProtocol = OperationDataManager(settingsStorage: self.settingsStorage)
    // TODO
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack.shared
    lazy var firebaseManager: FirebaseManagerProtocol = FirebaseManager(settingsStorage: self.settingsStorage)
    lazy var themeStorage: ThemeStorageProtocol = ThemeStorage()
    lazy var settingsStorage: SettingsStorageProtocol = SettingsStorage(themeStorage: self.themeStorage)
}
