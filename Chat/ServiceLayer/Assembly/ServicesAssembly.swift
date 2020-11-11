//
//  ServicesAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var loger: LogerProtocol { get }
    var settingsService: SettingsServiceProtocol { get }
    
    var fetchService: FetchServiceProtocol { get }
    var channelService: ChannelServiceProtocol { get }
    func messageService(with channel: Channel?) -> MessageServiceProtocol
    
    var themeService: ThemesServiceProtocol { get }
    var dataService: DataServiceProtocol { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {
    // MARK: - Dependencies
    private let coreAssembly: CoreAssemblyProtocol
    
    // MARK: - Init / deinit
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    // MARK: - ThemesModelProtocol
    lazy var loger: LogerProtocol = Loger(coreDataStack: self.coreAssembly.coreDataStack)
    lazy var settingsService: SettingsServiceProtocol = SettingsService(settingsStorage: self.coreAssembly.settingsStorage)
    
    lazy var themeService: ThemesServiceProtocol = ThemesService(themeStorage: self.coreAssembly.themeStorage)
    lazy var dataService: DataServiceProtocol = DataService(gcdDataManager: self.coreAssembly.gcdDataManager,
                                                            operationDataManager: self.coreAssembly.operationDataManager)
    
    lazy var fetchService: FetchServiceProtocol = FetchService(coreDataStack: self.coreAssembly.coreDataStack)
    lazy var channelService: ChannelServiceProtocol = ChannelService(coreDataStack: self.coreAssembly.coreDataStack,
                                                                     firebaseManager: self.coreAssembly.firebaseManager)
    func messageService(with channel: Channel?) -> MessageServiceProtocol {
        return MessageService(coreDataStack: self.coreAssembly.coreDataStack,
                              firebaseManager: self.coreAssembly.firebaseManager,
                              channel: channel)
    }
}
