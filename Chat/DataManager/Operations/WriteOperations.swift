//
//  WriteOperations.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class WriteOperation: Operation {
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let nameFile = "ProfileName.txt"
    let bioFile = "ProfileBio.txt"
    let imageFile = "ProfileImage.png"

    var hasSucceeded: Bool?
    
    override func main() {
        if isCancelled { return }
        
        if let dir = urlDir {
            let nameFileURL = dir.appendingPathComponent(nameFile)
            let bioFileURL = dir.appendingPathComponent(bioFile)
            let imageFileURL = dir.appendingPathComponent(imageFile)

            do {
                if let nameChanged = OperationDataManager.profileViewController?.nameDidChange, nameChanged {
                    try ProfileViewController.name?.write(to: nameFileURL, atomically: false, encoding: .utf8)
                }
                if let bioChanged = OperationDataManager.profileViewController?.bioDidChange, bioChanged {
                    try ProfileViewController.bio?.write(to: bioFileURL, atomically: false, encoding: .utf8)
                }
                //ДАТУ ВЫНЕСТИ ОТДЕЛЬНО?
                if let data = ProfileViewController.image?.jpegData(compressionQuality: 0) ?? ProfileViewController.image?.pngData(), OperationDataManager.profileViewController?.imageDidChange ?? true {
                    try data.write(to: imageFileURL)
                }
                hasSucceeded = true
            }
            catch {
                hasSucceeded = false
            }
        }
    }
}

class UpdateViewOperation: Operation {
    var succeed: Bool? {
        let operation = dependencies.first{ $0 is WriteOperation } as? WriteOperation
        return operation?.hasSucceeded
    }
    
    override func main() {
        if isCancelled { return }
        
        if let result = succeed, result {
            OperationDataManager.profileViewController?.activityIndicator.stopAnimating()
            OperationDataManager.profileViewController?.referToFile(action: .read, dataManager: .operation)
            OperationDataManager.profileViewController?.configureAlert("Data has been successfully saved", nil, false)
            OperationDataManager.profileViewController?.editProfileButton.isEnabled = true
            OperationDataManager.profileViewController?.setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        } else {
            OperationDataManager.profileViewController?.configureAlert("Error", "Failed to save data", true)
        }
    }
}
