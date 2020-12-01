//
//  CoreAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var gcdDataManager: IDataManager { get }
    var operationDataManager: IDataManager { get }
    var coreDataStack: ICoreDataStack { get }
    var firebaseManager: IFirebaseManager { get }
    var themeStorage: IThemeStorage { get }
    var settingsStorage: ISettingsStorage { get }
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var gcdDataManager: IDataManager = GCDDataManager(settingsStorage: self.settingsStorage)
    lazy var operationDataManager: IDataManager = OperationDataManager(settingsStorage: self.settingsStorage)
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
    lazy var firebaseManager: IFirebaseManager = FirebaseManager(settingsStorage: self.settingsStorage)
    lazy var themeStorage: IThemeStorage = ThemeStorage()
    lazy var settingsStorage: ISettingsStorage = SettingsStorage(themeStorage: self.themeStorage)
    lazy var requestSender: IRequestSender = RequestSender()
}
