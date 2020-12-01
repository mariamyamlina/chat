//
//  GCDDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class GCDDataManager {
    private let mainQueue = DispatchQueue.main
    private let queue = DispatchQueue(label: "com.chat.gcddatamanager", qos: .userInteractive, attributes: .concurrent)
    
    // MARK: - Dependencies
    var settingsStorage: ISettingsStorage

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
}

// MARK: - IDataManager
extension GCDDataManager: IDataManager {
    func save(nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        let group = DispatchGroup()

        var nameSaved = true
        var bioSaved = true
        var imageSaved = true
        
        group.enter()
        queue.async {
            if nameDidChange {
                if (try? self.settingsStorage.name?.write(to: self.settingsStorage.nameFileURL, atomically: false, encoding: .utf8)) == nil {
                    nameSaved = false
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if bioDidChange {
                if (try? self.settingsStorage.bio?.write(to: self.settingsStorage.bioFileURL, atomically: false, encoding: .utf8)) == nil {
                    bioSaved = false
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if imageDidChange {
                if (try? self.settingsStorage.image?.jpegData(compressionQuality: 0.5)?
                    .write(to: self.settingsStorage.imageFileURL)) == nil {
                    imageSaved = false
                }
            }
            group.leave()
        }
        
        group.notify(queue: queue) {
            self.mainQueue.async {
                completion(nameSaved, bioSaved, imageSaved)
            }
        }
    }
    
    func load(mustReadBio: Bool, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        queue.async {
            if let name = try? String(data: Data(contentsOf: self.settingsStorage.nameFileURL), encoding: .utf8) {
                self.settingsStorage.name = name
            } else {
                self.settingsStorage.name = "Marina Dudarenko"
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if mustReadBio {
                if let bio = try? String(data: Data(contentsOf: self.settingsStorage.bioFileURL), encoding: .utf8) {
                    self.settingsStorage.bio = bio
                } else {
                    self.settingsStorage.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            self.settingsStorage.image = try? UIImage(data: Data(contentsOf: self.settingsStorage.imageFileURL))
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
