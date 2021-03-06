//
//  PresentationAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    func logModel() -> ILogModel
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController(channel: Channel?) -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func collectionViewController() -> CollectionViewController
}

class PresentationAssembly: IPresentationAssembly {
    // MARK: - Dependencies
    private let serviceAssembly: IServicesAssembly
    
    // MARK: Init / deinit
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - LogViewController
    func logModel() -> ILogModel {
        return LogModel(loger: serviceAssembly.loger, settingsService: serviceAssembly.settingsService)
    }
    
    // MARK: - ConversationsListViewController
    func conversationsListViewController() -> ConversationsListViewController {
        let model = conversationsListModel()
        let conversationsListVC = ConversationsListViewController(model: model, presentationAssembly: self)
        return conversationsListVC
    }
    
    private func conversationsListModel() -> IConversationsListModel {
        return ConversationsListModel(channelService: serviceAssembly.channelService,
                                      dataService: serviceAssembly.dataService,
                                      settingsService: serviceAssembly.settingsService,
                                      fetchService: serviceAssembly.fetchService)
    }
    
    // MARK: - ConversationViewController
    func conversationViewController(channel: Channel?) -> ConversationViewController {
        let model = conversationModel(channel: channel)
        let conversationVC = ConversationViewController(model: model, presentationAssembly: self)
        return conversationVC
    }
    
    private func conversationModel(channel: Channel?) -> IConversationModel {
        return ConversationModel(messageService: serviceAssembly.messageService(with: channel),
                                 settingsService: serviceAssembly.settingsService,
                                 fetchService: serviceAssembly.fetchService,
                                 channel: channel)
    }
    
    // MARK: - ProfileViewController
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        let profileVC = ProfileViewController(model: model, presentationAssembly: self)
        return profileVC
    }
    
    private func profileModel() -> IProfileModel {
        return ProfileModel(dataService: serviceAssembly.dataService,
                            loger: serviceAssembly.loger,
                            settingsService: serviceAssembly.settingsService)
    }
    
    // MARK: - ThemesViewController
    func themesViewController() -> ThemesViewController {
        let model = themesModel()
        let themesVC = ThemesViewController(model: model, presentationAssembly: self)
        return themesVC
    }
    
    private func themesModel() -> ThemesModel {
        return ThemesModel(themeService: serviceAssembly.themeService,
                           settingsService: serviceAssembly.settingsService)
    }
    
    // MARK: - CollectionViewController
    func collectionViewController() -> CollectionViewController {
        let model = collectionModel()
        let collectionVC = CollectionViewController(model: model, presentationAssembly: self)
        return collectionVC
    }
    
    private func collectionModel() -> CollectionModel {
        return CollectionModel(settingsService: serviceAssembly.settingsService, imagesService: serviceAssembly.imagesService)
    }
}
