//
//  GCDDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class GCDDataManager: SaveDataDelegate {
    
    static var profileViewController: ProfileViewController?

    init() {
        GCDDataManager.profileViewController?.delegate = self
    }
    
    func writeToFile(nameText: String?, bioText: String?, image: UIImage?) {
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global(qos: .userInitiated)
        
        let imageData = image?.jpegData(compressionQuality: 0) ?? image?.pngData()
        
        globalQueue.async {
            
            if let dir = ProfileViewController.urlDir {
                let nameFileURL = dir.appendingPathComponent(ProfileViewController.nameFile)
                let bioFileURL = dir.appendingPathComponent(ProfileViewController.bioFile)
                let imageFileURL = dir.appendingPathComponent(ProfileViewController.imageFile)

                do {
                    mainQueue.async {
                        GCDDataManager.profileViewController?.editProfileButton.isEnabled = false
                        GCDDataManager.profileViewController?.activityIndicator.startAnimating()
                    }
                    
                    if GCDDataManager.profileViewController?.nameDidChange ?? true {
                        try nameText?.write(to: nameFileURL, atomically: false, encoding: .utf8)
                    }
                    if GCDDataManager.profileViewController?.bioDidChange ?? true {
                        try bioText?.write(to: bioFileURL, atomically: false, encoding: .utf8)
                    }
                    
//                        if let data = image?.jpegData(compressionQuality: 0) ?? image?.pngData(), GCDDataManager.profileViewController?.imageDidChange ?? true {
                    if let data = imageData, GCDDataManager.profileViewController?.imageDidChange ?? true {
                        try data.write(to: imageFileURL)
                    }
                    
                    mainQueue.async {
                        GCDDataManager.profileViewController?.activityIndicator.stopAnimating()
                        GCDDataManager.profileViewController?.referToFile(action: .read, dataManager: .gcd)
                        GCDDataManager.profileViewController?.configureAlert("Data has been successfully saved", nil, false)
                        GCDDataManager.profileViewController?.editProfileButton.isEnabled = true
                        GCDDataManager.profileViewController?.setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
                    }
                }
                catch {
                    mainQueue.async {
                        GCDDataManager.profileViewController?.configureAlert("Error", "Failed to save data", true)
                    }
                }
            }
        }
    }
    
    func readNameFromFile() {
        let globalQueue = DispatchQueue.global(qos: .userInitiated)

        globalQueue.sync {
            if let dir = ProfileViewController.urlDir {
                let nameFileURL: URL = dir.appendingPathComponent(ProfileViewController.nameFile)
                var nameFromFile: String?

                do {
                    nameFromFile = try String(data: Data(contentsOf: nameFileURL), encoding: .utf8)
                }
                catch {
                    ProfileViewController.name = "Marina Dudarenko"
                }
                
                if let name = nameFromFile {
                    ProfileViewController.name = name
                }
            }
        }
    }
    
    func readBioFromFile() {
        let globalQueue = DispatchQueue.global(qos: .userInitiated)

        globalQueue.sync {
            if let dir = ProfileViewController.urlDir {
                let bioFileURL: URL = dir.appendingPathComponent(ProfileViewController.bioFile)
                var bioFromFile: String?

                do {
                    bioFromFile = try String(data: Data(contentsOf: bioFileURL), encoding: .utf8)
                }
                catch {
                    ProfileViewController.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                }
                
                if let bio = bioFromFile {
                    ProfileViewController.bio = bio
                }
            }
        }
    }
    
    func readImageFromFile() {
        let globalQueue = DispatchQueue.global(qos: .userInitiated)

        globalQueue.sync {
            if let dir = ProfileViewController.urlDir {
                let imageFileURL: URL = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(ProfileViewController.imageFile)
                var imageFromFile: UIImage?

                do {
                    imageFromFile = try UIImage(data: Data(contentsOf: imageFileURL))
                }
                catch {
                    ProfileViewController.image = nil
                }
                
                if let image = imageFromFile {
                    ProfileViewController.image = image
                }
            }
        }
    }
}

