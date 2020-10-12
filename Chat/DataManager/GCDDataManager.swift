//
//  GCDDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class GCDDataManager: DataManagerDelegate {
    
    static var profileViewController: ProfileViewController?
    
    private let mainQueue = DispatchQueue.main
    private let queue = DispatchQueue(label: "GCD", qos: .userInitiated)
    
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let nameFile = "ProfileName.txt"
    let bioFile = "ProfileBio.txt"
    let imageFile = "ProfileImage.png"
    
    var nameFileURL: URL
    var bioFileURL: URL
    var imageFileURL: URL

    init() {
        nameFileURL = urlDir?.appendingPathComponent(nameFile) ?? URL(fileURLWithPath: "")
        bioFileURL = urlDir?.appendingPathComponent(bioFile) ?? URL(fileURLWithPath: "")
        imageFileURL = urlDir?.appendingPathComponent(imageFile) ?? URL(fileURLWithPath: "")
        
        GCDDataManager.profileViewController?.delegate = self
    }
    
    func writeToFile(nameText: String?, bioText: String?, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var errorsCounter = 0
        
        let imageData = image?.jpegData(compressionQuality: 0) ?? image?.pngData()
        
        GCDDataManager.profileViewController?.editProfileButton.isEnabled = false
        GCDDataManager.profileViewController?.activityIndicator.startAnimating()
        
        group.enter()
        queue.async {
            if let nameChanged = GCDDataManager.profileViewController?.nameDidChange, nameChanged {
                do {
                    try nameText?.write(to: self.nameFileURL, atomically: false, encoding: .utf8)
                }
                catch {
                    errorsCounter += 1
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let bioChanged = GCDDataManager.profileViewController?.bioDidChange, bioChanged {
                do {
                    try bioText?.write(to: self.bioFileURL, atomically: false, encoding: .utf8)
                }
                catch {
                    errorsCounter += 1
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let imageChanged = GCDDataManager.profileViewController?.imageDidChange, imageChanged {
                do {
                    try imageData?.write(to: self.imageFileURL)
                }
                catch {
                    errorsCounter += 1
                }
            }
            group.leave()
        }
        
        group.notify(queue: queue) {
            self.mainQueue.async {
                completion(errorsCounter == 0)
            }
        }
    }
    
    func readFromFile(mustReadName: Bool = true, mustReadBio: Bool = true, mustReadImage: Bool = true) {
        let group = DispatchGroup()
        
        group.enter()
        queue.sync {
            if mustReadName {
                do {
                    let nameFromFile = try String(data: Data(contentsOf: self.nameFileURL), encoding: .utf8)
                    if let name = nameFromFile {
                        ProfileViewController.name = name
                    }
                }
                catch {
                    ProfileViewController.name = "Marina Dudarenko"
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.sync {
            if mustReadBio {
                do {
                    let bioFromFile = try String(data: Data(contentsOf: self.bioFileURL), encoding: .utf8)
                    if let bio = bioFromFile {
                        ProfileViewController.bio = bio
                    }
                }
                catch {
                    ProfileViewController.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.sync {
            if mustReadImage {
                do {
                    let imageFromFile = try UIImage(data: Data(contentsOf: self.imageFileURL))
                    if let image = imageFromFile {
                        ProfileViewController.image = image
                    }
                }
                catch {
                    ProfileViewController.image = nil
                }
            }
            group.leave()
        }
    }
}

