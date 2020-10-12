//
//  WriteOperations.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class WriteOperation: Operation {
    private var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private let nameFile = "ProfileName.txt"
    private let bioFile = "ProfileBio.txt"
    private let imageFile = "ProfileImage.png"

    var hasSucceeded = true
    
    override func main() {
        if isCancelled { return }
        
        let nameFileURL = urlDir?.appendingPathComponent(nameFile) ?? URL(fileURLWithPath: "")
        let bioFileURL = urlDir?.appendingPathComponent(bioFile) ?? URL(fileURLWithPath: "")
        let imageFileURL = urlDir?.appendingPathComponent(imageFile) ?? URL(fileURLWithPath: "")
        
        do {
            if let nameChanged = OperationDataManager.profileViewController?.nameDidChange,
                nameChanged {
                try ProfileViewController.name?.write(to: nameFileURL, atomically: false, encoding: .utf8)
            }
            if let bioChanged = OperationDataManager.profileViewController?.bioDidChange,
                bioChanged {
                try ProfileViewController.bio?.write(to: bioFileURL, atomically: false, encoding: .utf8)
            }
            if let data = ProfileViewController.image?.jpegData(compressionQuality: 1.0) ?? ProfileViewController.image?.pngData(),
                let imageChanged = OperationDataManager.profileViewController?.imageDidChange,
                imageChanged {
                try data.write(to: imageFileURL)
            }
        }
        catch {
            hasSucceeded = false
        }
    }
}
