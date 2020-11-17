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
                do {
                    try self.settingsStorage.name?.write(to: self.settingsStorage.nameFileURL, atomically: false, encoding: .utf8)
                } catch {
                    nameSaved = false
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if bioDidChange {
                do {
                    try self.settingsStorage.bio?.write(to: self.settingsStorage.bioFileURL, atomically: false, encoding: .utf8)
                } catch {
                    bioSaved = false
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let data = self.settingsStorage.image?.jpegData(compressionQuality: 0.5),
                imageDidChange {
                do {
                    try data.write(to: self.settingsStorage.imageFileURL)
                } catch {
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
            do {
                if let name = try String(data: Data(contentsOf: self.settingsStorage.nameFileURL), encoding: .utf8) {
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
                    if let bio = try String(data: Data(contentsOf: self.settingsStorage.bioFileURL), encoding: .utf8) {
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
                if let image = try UIImage(data: Data(contentsOf: self.settingsStorage.imageFileURL)) {
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
