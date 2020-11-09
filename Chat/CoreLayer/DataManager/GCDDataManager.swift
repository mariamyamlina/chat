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
}

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
                    try ProfileViewController.name?.write(to: DataService.nameFileURL, atomically: false, encoding: .utf8)
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
                    try ProfileViewController.bio?.write(to: DataService.bioFileURL, atomically: false, encoding: .utf8)
                } catch {
                    bioSaved = false
                }
                ProfileViewController.bioDidChange = !bioSaved
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let data = ProfileViewController.image?.jpegData(compressionQuality: 0.5),
                ProfileViewController.imageDidChange {
                do {
                    try data.write(to: DataService.imageFileURL)
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
    
    func load(mustReadName: Bool = true, mustReadBio: Bool = true, mustReadImage: Bool = true, completion: @escaping (Bool, Bool, Bool) -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        queue.async {
            if mustReadName {
                do {
                    let nameFromFile = try String(data: Data(contentsOf: DataService.nameFileURL), encoding: .utf8)
                    if let name = nameFromFile {
                        ProfileViewController.name = name
                    }
                } catch {
                    ProfileViewController.name = "Marina Dudarenko"
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if mustReadBio {
                do {
                    let bioFromFile = try String(data: Data(contentsOf: DataService.bioFileURL), encoding: .utf8)
                    if let bio = bioFromFile {
                        ProfileViewController.bio = bio
                    }
                } catch {
                    ProfileViewController.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                }
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if mustReadImage {
                do {
                    let imageFromFile = try UIImage(data: Data(contentsOf: DataService.imageFileURL))
                    if let image = imageFromFile {
                        ProfileViewController.image = image
                    }
                } catch {
                    ProfileViewController.image = nil
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(mustReadName, mustReadBio, mustReadImage)
        }
    }
}