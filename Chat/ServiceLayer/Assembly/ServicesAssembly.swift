//
//  ServicesAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var loger: ILoger { get }
    var settingsService: ISettingsService { get }
    
    var fetchService: IFetchService { get }
    var channelService: IChannelService { get }
    func messageService(with channel: Channel?) -> IMessageService
    
    var themeService: IThemesService { get }
    var dataService: IDataService { get }
    
    var imagesService: IImagesService { get }
}

class ServicesAssembly: IServicesAssembly {
    // MARK: - Dependencies
    private let coreAssembly: ICoreAssembly
    
    // MARK: - Init / deinit
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    // MARK: - IThemesModel
    lazy var loger: ILoger = Loger(coreDataStack: self.coreAssembly.coreDataStack)
    lazy var settingsService: ISettingsService = SettingsService(settingsStorage: self.coreAssembly.settingsStorage)
    
    lazy var themeService: IThemesService = ThemesService(themeStorage: self.coreAssembly.themeStorage)
    lazy var dataService: IDataService = DataService(gcdDataManager: self.coreAssembly.gcdDataManager,
                                                            operationDataManager: self.coreAssembly.operationDataManager)
    
    lazy var fetchService: IFetchService = FetchService(coreDataStack: self.coreAssembly.coreDataStack)
    lazy var channelService: IChannelService = ChannelService(coreDataStack: self.coreAssembly.coreDataStack,
                                                                     firebaseManager: self.coreAssembly.firebaseManager)
    func messageService(with channel: Channel?) -> IMessageService {
        return MessageService(coreDataStack: self.coreAssembly.coreDataStack,
                              firebaseManager: self.coreAssembly.firebaseManager,
                              channel: channel)
    }
    
    lazy var imagesService: IImagesService = ImagesService(requestSender: self.coreAssembly.requestSender)
}
