//
//  OperationDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class OperationDataManager: SaveDataDelegate {
    static var profileViewController: ProfileViewController?

    init() {
        OperationDataManager.profileViewController?.delegate = self
    }
    
    func writeToFile(nameText: String?, bioText: String?, image: UIImage?) {
        
        ProfileViewController.name = nameText
        ProfileViewController.bio = bioText
        ProfileViewController.image = image
        
        OperationDataManager.profileViewController?.editProfileButton.isEnabled = false
        OperationDataManager.profileViewController?.activityIndicator.startAnimating()
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let writeOperation = WriteOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateViewOperation()
        
        uiOperation.addDependency(writeOperation)
        operationQueue.addOperations([writeOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
    
    func readNameFromFile() {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let readOperation = ReadNameOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateNameOperation()
        
        uiOperation.addDependency(readOperation)
        operationQueue.addOperations([readOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
    
    func readBioFromFile() {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let readOperation = ReadBioOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateBioOperation()
        
        uiOperation.addDependency(readOperation)
        operationQueue.addOperations([readOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
    
    func readImageFromFile() {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let readOperation = ReadImageOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateImageOperation()
        
        uiOperation.addDependency(readOperation)
        operationQueue.addOperations([readOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
}

class WriteOperation: Operation {
    var hasSucceeded: Bool?
    
    override func main() {
        if let dir = ProfileViewController.urlDir {
            let nameFileURL = dir.appendingPathComponent(ProfileViewController.nameFile)
            let bioFileURL = dir.appendingPathComponent(ProfileViewController.bioFile)
            let imageFileURL = dir.appendingPathComponent(ProfileViewController.imageFile)

            do {
                if OperationDataManager.profileViewController?.nameDidChange ?? true {
                    try ProfileViewController.name?.write(to: nameFileURL, atomically: false, encoding: .utf8)
                }
                if OperationDataManager.profileViewController?.bioDidChange ?? true {
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

class ReadNameOperation: Operation {
    var hasSucceeded: Bool?
    
    override func main() {
        if let dir = ProfileViewController.urlDir {
            let nameFileURL: URL = dir.appendingPathComponent(ProfileViewController.nameFile)
            var nameFromFile: String?

            do {
                nameFromFile = try String(data: Data(contentsOf: nameFileURL), encoding: .utf8)
                hasSucceeded = true
            }
            catch {
                ProfileViewController.name = "Marina Dudarenko"
                hasSucceeded = false
            }
            
            if let name = nameFromFile {
                ProfileViewController.name = name
            }
        }
    }
}

class UpdateNameOperation: Operation {
    var succeed: Bool? {
        let operation = dependencies.first{ $0 is ReadNameOperation } as? ReadNameOperation
        return operation?.hasSucceeded
    }
    
    override func main() {
        OperationDataManager.profileViewController?.nameTextView.text = ProfileViewController.name
    }
}

class ReadBioOperation: Operation {
    var hasSucceeded: Bool?
    
    override func main() {
        if let dir = ProfileViewController.urlDir {
            let bioFileURL: URL = dir.appendingPathComponent(ProfileViewController.bioFile)
            var bioFromFile: String?

            do {
                bioFromFile = try String(data: Data(contentsOf: bioFileURL), encoding: .utf8)
                hasSucceeded = true
            }
            catch {
                ProfileViewController.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                hasSucceeded = false
            }
            
            if let bio = bioFromFile {
                ProfileViewController.bio = bio
            }
        }
    }
}

class UpdateBioOperation: Operation {
    var succeed: Bool? {
        let operation = dependencies.first{ $0 is ReadBioOperation } as? ReadBioOperation
        return operation?.hasSucceeded
    }
    
    override func main() {
        OperationDataManager.profileViewController?.bioTextView.text = ProfileViewController.bio
    }
}

class ReadImageOperation: Operation {
    var hasSucceeded: Bool?
    
    override func main() {
        if let dir = ProfileViewController.urlDir {
            let imageFileURL: URL = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(ProfileViewController.imageFile)
            var imageFromFile: UIImage?

            do {
                imageFromFile = try UIImage(data: Data(contentsOf: imageFileURL))
                hasSucceeded = true
            }
            catch {
                ProfileViewController.image = nil
                hasSucceeded = false
            }
            
            if let image = imageFromFile {
                ProfileViewController.image = image
            }
        }
    }
}

class UpdateImageOperation: Operation {
    var succeed: Bool? {
        let operation = dependencies.first{ $0 is ReadImageOperation } as? ReadImageOperation
        return operation?.hasSucceeded
    }
    
    override func main() {
        if let result = succeed, result {
            OperationDataManager.profileViewController?.profileImageView.updateImage()
        }
    }
}
