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
}

class PresentationAssembly: PresentationAssemblyProtocol {
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) { self.serviceAssembly = serviceAssembly }
    
    // MARK: - ConversationsListViewController
    
    func conversationsListViewController() -> ConversationsListViewController {
        let model = conversationsListModel()
        let conversationsListVC = ConversationsListViewController(model: model, presentationAssembly: self)
        model.delegate = conversationsListVC
        return conversationsListVC
    }
    
    private func conversationsListModel() -> ConversationsListModelProtocol {
        return ConversationsListModel(firebaseService: serviceAssembly.firebaseService, fetchService: serviceAssembly.fetchService(with: nil))
    }
    
    // MARK: - ConversationViewController
    
    func conversationViewController(channel: Channel?) -> ConversationViewController {
        let model = conversationModel(channel: channel)
        let conversationVC = ConversationViewController(model: model, presentationAssembly: self)
        model.delegate = conversationVC
        return conversationVC
    }
    
    private func conversationModel(channel: Channel?) -> ConversationModelProtocol {
        return ConversationModel(firebaseService: serviceAssembly.firebaseService, fetchService: serviceAssembly.fetchService(with: channel), channel: channel)
    }
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        let profileVC = ProfileViewController(model: model, presentationAssembly: self)
//        model.delegate = profileVC
        return profileVC
    }
    
    private func profileModel() -> ProfileModelProtocol {
        return ProfileModel(dataService: serviceAssembly.dataService)
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
