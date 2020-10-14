//
//  ReadOperations.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ReadNameOperation: Operation {
    override func main() {
        if isCancelled { return }
        do {
            let nameFromFile = try String(data: Data(contentsOf: DataManager.nameFileURL), encoding: .utf8)
            if let name = nameFromFile {
                ProfileViewController.name = name
            }
        }
        catch {
            ProfileViewController.name = "Marina Dudarenko"
        }
    }
}

class ReadBioOperation: Operation {
    override func main() {
        if isCancelled { return }
        do {
            let bioFromFile = try String(data: Data(contentsOf: DataManager.bioFileURL), encoding: .utf8)
            if let bio = bioFromFile {
                ProfileViewController.bio = bio
            }
        }
        catch {
            ProfileViewController.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
        }
    }
}

class ReadImageOperation: Operation {
    override func main() {
        if isCancelled { return }
        do {
            let imageFromFile = try UIImage(data: Data(contentsOf: DataManager.imageFileURL))
            if let image = imageFromFile {
                ProfileViewController.image = image
            }
        }
        catch {
            ProfileViewController.image = nil
        }
    }
}
