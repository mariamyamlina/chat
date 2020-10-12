//
//  ReadOperations.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ReadNameOperation: Operation {
    private var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private let nameFile = "ProfileName.txt"
    private let bioFile = "ProfileBio.txt"
    private let imageFile = "ProfileImage.png"
    
    var hasSucceeded = true
    
    override func main() {
        if isCancelled { return }        
        let nameFileURL = urlDir?.appendingPathComponent(nameFile) ?? URL(fileURLWithPath: "")
        
        do {
            let nameFromFile = try String(data: Data(contentsOf: nameFileURL), encoding: .utf8)
            if let name = nameFromFile {
                ProfileViewController.name = name
            }
        }
        catch {
            ProfileViewController.name = "Marina Dudarenko"
            hasSucceeded = false
        }
    }
}

class ReadBioOperation: Operation {
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let nameFile = "ProfileName.txt"
    let bioFile = "ProfileBio.txt"
    let imageFile = "ProfileImage.png"
    
    var hasSucceeded = true
    
    override func main() {
        if isCancelled { return }
        let bioFileURL = urlDir?.appendingPathComponent(bioFile) ?? URL(fileURLWithPath: "")

        do {
            let bioFromFile = try String(data: Data(contentsOf: bioFileURL), encoding: .utf8)
            if let bio = bioFromFile {
                ProfileViewController.bio = bio
            }
        }
        catch {
            ProfileViewController.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
            hasSucceeded = false
        }
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
        let imageFileURL = urlDir?.appendingPathComponent(imageFile) ?? URL(fileURLWithPath: "")

        do {
            let imageFromFile = try UIImage(data: Data(contentsOf: imageFileURL))
            if let image = imageFromFile {
                ProfileViewController.image = image
            }
        }
        catch {
            ProfileViewController.image = nil
            hasSucceeded = false
        }
    }
}
