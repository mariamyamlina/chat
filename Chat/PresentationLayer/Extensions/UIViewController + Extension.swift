//
//  UIViewController + Extension.swift
//  Chat
//
//  Created by Maria Myamlina on 09.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: self)
        return navigationVC
    }
    
    func configureNewChannelAlert(model: IConversationsListModel,
                                  view: ConversationsListView) {
        let alertController = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        view.setupTextField(alertController.textFields?[0])
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak model, weak alertController] _ in
            if let channelName = alertController?.textFields![0].text,
                !channelName.containtsOnlyOfWhitespaces() {
                model?.createChannel(withName: channelName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [createAction, cancelAction].forEach { alertController.addAction($0) }
        alertController.applyTheme(theme: model.currentTheme)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureAlert(model: IProfileModel,
                        view: ProfileView,
                        changeInfoIndicator: [Bool],
                        completion: @escaping (Bool, Bool, Bool) -> Void,
                        title: String,
                        message: String?,
                        needsTwoActions: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak view] (_: UIAlertAction) in
            guard let unwrView = view else { return }
            if title != "Error" {
                if unwrView.gcdButtonTapped {
                    unwrView.gcdButtonTapped = false
                } else if unwrView.operationButtonTapped {
                    unwrView.operationButtonTapped = false
                }
                unwrView.editProfileButton.isEnabled = true
                unwrView.setupButtonView(button: unwrView.editProfileButton, title: "Edit Profile", color: .systemBlue)
            }
        })
        alertController.addAction(cancelAction)
        
        if needsTwoActions {
            let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { [weak model, weak view] (_: UIAlertAction) in
                guard let unwrView = view else { return }
                if unwrView.gcdButtonTapped {
                    model?.saveWithGCD(nameDidChange: changeInfoIndicator[0],
                                       bioDidChange: changeInfoIndicator[1],
                                       imageDidChange: changeInfoIndicator[2],
                                       completion: completion)
                } else if unwrView.operationButtonTapped {
                    model?.saveWithOperations(nameDidChange: changeInfoIndicator[0],
                                              bioDidChange: changeInfoIndicator[1],
                                              imageDidChange: changeInfoIndicator[2],
                                              completion: completion)
                }
            })
            alertController.addAction(repeatAction)
        }
        alertController.applyTheme(theme: model.currentTheme)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureImagePickerAlert(model: IProfileModel,
                                   completion: @escaping (UIImagePickerController.SourceType) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.pruneNegativeWidthConstraints()
        let galeryAction = UIAlertAction(title: "Choose from gallery", style: .default) { (_) in
            completion(.photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { (_) in
            completion(.camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        [galeryAction, takePhotoAction, cancelAction].forEach { alertController.addAction($0) }
        alertController.applyTheme(theme: model.currentTheme)
        self.present(alertController, animated: true, completion: nil)
    }
}
