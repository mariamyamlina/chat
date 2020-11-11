//
//  PresentationAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController(channel: Channel?) -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func logModel() -> LogModelProtocol
}

class PresentationAssembly: PresentationAssemblyProtocol {
    // MARK: - Dependencies
    private let serviceAssembly: ServicesAssemblyProtocol
    
    // MARK: Init / deinit
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - LogViewController
    func logModel() -> LogModelProtocol {
        return LogModel(loger: serviceAssembly.loger)
    }
    
    // MARK: - ConversationsListViewController
    func conversationsListViewController() -> ConversationsListViewController {
        let model = conversationsListModel()
        let conversationsListVC = ConversationsListViewController(model: model, presentationAssembly: self)
        model.delegate = conversationsListVC
        return conversationsListVC
    }
    
    private func conversationsListModel() -> ConversationsListModelProtocol {
        return ConversationsListModel(channelService: serviceAssembly.channelService, dataService: serviceAssembly.dataService)
    }
    
    // MARK: - ConversationViewController
    func conversationViewController(channel: Channel?) -> ConversationViewController {
        let model = conversationModel(channel: channel)
        let conversationVC = ConversationViewController(model: model, presentationAssembly: self)
        model.delegate = conversationVC
        return conversationVC
    }
    
    private func conversationModel(channel: Channel?) -> ConversationModelProtocol {
        return ConversationModel(messageService: serviceAssembly.messageService(with: channel), channel: channel)
    }
    
    // MARK: - ProfileViewController
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        let profileVC = ProfileViewController(model: model, presentationAssembly: self)
//        model.delegate = profileVC
        return profileVC
    }
    
    private func profileModel() -> ProfileModelProtocol {
        return ProfileModel(dataService: serviceAssembly.dataService, loger: serviceAssembly.loger)
    }
    
    // MARK: - ThemesViewController
    func themesViewController() -> ThemesViewController {
        let model = themesModel()
        let themesVC = ThemesViewController(model: model, presentationAssembly: self)
//        model.delegate = themesVC
        return themesVC
    }
    
    private func themesModel() -> ThemesModel {
        return ThemesModel(themeService: serviceAssembly.themeService)
    }
}
