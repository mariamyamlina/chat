//
//  GCDDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class GCDDataManager {
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    lazy var nameFileURL: URL = { urlDir?.appendingPathComponent("ProfileName.txt") ?? URL(fileURLWithPath: "") }()
    lazy var bioFileURL: URL = { urlDir?.appendingPathComponent("ProfileBio.txt") ?? URL(fileURLWithPath: "") }()
    lazy var imageFileURL: URL = { urlDir?.appendingPathComponent("ProfileImage.jpeg") ?? URL(fileURLWithPath: "") }()
    
    private let mainQueue = DispatchQueue.main
    private let queue = DispatchQueue(label: "com.chat.gcddatamanager", qos: .userInteractive, attributes: .concurrent)
    
    // MARK: - Dependencies
    var settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
}

// MARK: - DataManagerProtocol
extension GCDDataManager: DataManagerProtocol {
    func save(completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()

        var nameSaved = true
        var bioSaved = true
        var imageSaved = true
        
        group.enter()
        queue.async {
            if ProfileViewController.nameDidChange {
                do {
                    try self.settingsStorage.name?.write(to: self.nameFileURL, atomically: false, encoding: .utf8)
                } catch {
                    nameSaved = false
                }
                ProfileViewController.nameDidChange = !nameSaved
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if ProfileViewController.bioDidChange {
                do {
                    try self.settingsStorage.bio?.write(to: self.bioFileURL, atomically: false, encoding: .utf8)
                } catch {
                    bioSaved = false
                }
                ProfileViewController.bioDidChange = !bioSaved
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let data = self.settingsStorage.image?.jpegData(compressionQuality: 0.5),
                ProfileViewController.imageDidChange {
                do {
                    try data.write(to: self.imageFileURL)
                } catch {
                    imageSaved = false
                }
                ProfileViewController.imageDidChange = !imageSaved
            }
            group.leave()
        }
        
        group.notify(queue: queue) {
            self.mainQueue.async {
                let result = nameSaved && bioSaved && imageSaved
                completion(result)
            }
        }
    }
    
    func load(mustReadBio: Bool, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        queue.async {
            do {
                let nameFromFile = try String(data: Data(contentsOf: self.nameFileURL), encoding: .utf8)
                if let name = nameFromFile {
                    self.settingsStorage.name = name
                }
            } catch {
                self.settingsStorage.name = "Marina Dudarenko"
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if mustReadBio {
                do {
                    let bioFromFile = try String(data: Data(contentsOf: self.bioFileURL), encoding: .utf8)
                    if let bio = bioFromFile {
                        self.settingsStorage.bio = bio
                    }
                } catch {
                    self.settingsStorage.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            do {
                let imageFromFile = try UIImage(data: Data(contentsOf: self.imageFileURL))
                if let image = imageFromFile {
                    self.settingsStorage.image = image
                }
            } catch {
                self.settingsStorage.image = nil
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
