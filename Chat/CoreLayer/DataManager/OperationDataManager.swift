//
//  OperationDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class OperationDataManager {
    private let operationQueue = OperationQueue()
    private let mainOperationQueue = OperationQueue.main
    
    // MARK: - Dependencies
    let settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
}

// MARK: - DataManagerProtocol
extension OperationDataManager: DataManagerProtocol {
    func save(completion: @escaping (Bool) -> Void) {
        let writeOperation = WriteOperation(settingsStorage: settingsStorage)
        let completionOperation = BlockOperation {
            let result = writeOperation.nameSaved && writeOperation.bioSaved && writeOperation.imageSaved
            completion(result)
        }
        
        completionOperation.addDependency(writeOperation)
        operationQueue.addOperations([writeOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(completionOperation)
    }
    
    func load(mustReadBio: Bool = true, completion: @escaping () -> Void) {
        let readNameOperation = ReadNameOperation(settingsStorage: settingsStorage)
        let readBioOperation = ReadBioOperation(settingsStorage: settingsStorage)
        let readImageOperation = ReadImageOperation(settingsStorage: settingsStorage)
        let completionOperation = BlockOperation {
            completion()
        }

        completionOperation.addDependency(readNameOperation)
        completionOperation.addDependency(readBioOperation)
        completionOperation.addDependency(readImageOperation)
        operationQueue.addOperations([readNameOperation, readBioOperation, readImageOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(completionOperation)
    }
}

// MARK: - WriteOperation
class WriteOperation: Operation {
    var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    lazy var nameFileURL: URL = { urlDir?.appendingPathComponent("ProfileName.txt") ?? URL(fileURLWithPath: "") }()
    lazy var bioFileURL: URL = { urlDir?.appendingPathComponent("ProfileBio.txt") ?? URL(fileURLWithPath: "") }()
    lazy var imageFileURL: URL = { urlDir?.appendingPathComponent("ProfileImage.jpeg") ?? URL(fileURLWithPath: "") }()
    
    // MARK: - Dependencies
    let settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
    
    var nameSaved = true
    var bioSaved = true
    var imageSaved = true
    
    override func main() {
        if isCancelled { return }
        do {
            if ProfileViewController.nameDidChange {
                try settingsStorage.name?.write(to: nameFileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            nameSaved = false
        }
        ProfileViewController.nameDidChange = !nameSaved
        
        do {
            if ProfileViewController.bioDidChange {
                try settingsStorage.bio?.write(to: bioFileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            bioSaved = false
        }
        ProfileViewController.bioDidChange = !bioSaved
        
        do {
            if let data = settingsStorage.image?.jpegData(compressionQuality: 0.5),
                ProfileViewController.imageDidChange {
                try data.write(to: imageFileURL)
            }
        } catch {
            imageSaved = false
        }
        ProfileViewController.imageDidChange = !imageSaved
    }
}

// MARK: - ReadOperations
class ReadNameOperation: Operation {
    lazy var nameFileURL: URL = {
        var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return urlDir?.appendingPathComponent("ProfileName.txt") ?? URL(fileURLWithPath: "")
    }()
    
    // MARK: - Dependencies
    var settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
    
    override func main() {
        if isCancelled { return }
        do {
            let nameFromFile = try String(data: Data(contentsOf: nameFileURL), encoding: .utf8)
            if let name = nameFromFile {
                settingsStorage.name = name
            }
        } catch {
            settingsStorage.name = "Marina Dudarenko"
        }
    }
}

class ReadBioOperation: Operation {
    lazy var bioFileURL: URL = {
        var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return urlDir?.appendingPathComponent("ProfileBio.txt") ?? URL(fileURLWithPath: "")
    }()
    
    // MARK: - Dependencies
    var settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
    
    override func main() {
        if isCancelled { return }
        do {
            let bioFromFile = try String(data: Data(contentsOf: bioFileURL), encoding: .utf8)
            if let bio = bioFromFile {
                settingsStorage.bio = bio
            }
        } catch {
            settingsStorage.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
        }
    }
}

class ReadImageOperation: Operation {
    lazy var imageFileURL: URL = {
        var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return urlDir?.appendingPathComponent("ProfileImage.jpeg") ?? URL(fileURLWithPath: "")
    }()
    
    // MARK: - Dependencies
    var settingsStorage: SettingsStorageProtocol

    // MARK: - Init / deinit
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }
    
    override func main() {
        if isCancelled { return }
        do {
            let imageFromFile = try UIImage(data: Data(contentsOf: imageFileURL))
            if let image = imageFromFile {
                settingsStorage.image = image
            }
        } catch {
            settingsStorage.image = nil
        }
    }
}
