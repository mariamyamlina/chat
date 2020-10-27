//
//  WriteOperations.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class WriteOperation: Operation {
    var nameSaved = true
    var bioSaved = true
    var imageSaved = true
    
    override func main() {
        if isCancelled { return }
        do {
            if ProfileViewController.nameDidChange {
                try ProfileViewController.name?.write(to: DataManager.nameFileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            nameSaved = false
        }
        ProfileViewController.nameDidChange = !nameSaved
        
        do {
            if ProfileViewController.bioDidChange {
                try ProfileViewController.bio?.write(to: DataManager.bioFileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            bioSaved = false
        }
        ProfileViewController.bioDidChange = !bioSaved
        
        do {
            if let data = ProfileViewController.image?.jpegData(compressionQuality: 0.5),
                ProfileViewController.imageDidChange {
                try data.write(to: DataManager.imageFileURL)
            }
        } catch {
            imageSaved = false
        }
        ProfileViewController.imageDidChange = !imageSaved
    }
}
