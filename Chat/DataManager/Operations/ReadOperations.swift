//
//  ReadOperations.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ReadNameOperation: Operation {
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let nameFile = "ProfileName.txt"
    let bioFile = "ProfileBio.txt"
    let imageFile = "ProfileImage.png"
    
    var hasSucceeded: Bool?
    
    override func main() {
        if isCancelled { return }
        
        if let dir = urlDir {
            let nameFileURL: URL = dir.appendingPathComponent(nameFile)
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
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let nameFile = "ProfileName.txt"
    let bioFile = "ProfileBio.txt"
    let imageFile = "ProfileImage.png"
    
    var hasSucceeded: Bool?
    
    override func main() {
        if isCancelled { return }
        
        if let dir = urlDir {
            let bioFileURL: URL = dir.appendingPathComponent(bioFile)
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
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let nameFile = "ProfileName.txt"
    let bioFile = "ProfileBio.txt"
    let imageFile = "ProfileImage.png"
    
    var hasSucceeded: Bool?
    
    override func main() {
        if isCancelled { return }
        
        if let dir = urlDir {
            let imageFileURL: URL = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(imageFile)
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

