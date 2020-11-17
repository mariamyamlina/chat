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
    let settingsStorage: ISettingsStorage

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
}

// MARK: - IDataManager
extension OperationDataManager: IDataManager {
    func save(nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool, completion: @escaping (Bool, Bool, Bool) -> Void) {
        let writeOperation = WriteOperation(settingsStorage: settingsStorage,
                                            nameDidChange: nameDidChange,
                                            bioDidChange: bioDidChange,
                                            imageDidChange: imageDidChange)
        let completionOperation = BlockOperation {
            completion(writeOperation.nameSaved, writeOperation.bioSaved, writeOperation.imageSaved)
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
    // MARK: - Dependencies
    let settingsStorage: ISettingsStorage
    let nameDidChange: Bool
    let bioDidChange: Bool
    let imageDidChange: Bool

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage, nameDidChange: Bool, bioDidChange: Bool, imageDidChange: Bool) {
        self.settingsStorage = settingsStorage
        self.nameDidChange = nameDidChange
        self.bioDidChange = bioDidChange
        self.imageDidChange = imageDidChange
    }
    
    var nameSaved = true
    var bioSaved = true
    var imageSaved = true
    
    override func main() {
        if isCancelled { return }
        do {
            if nameDidChange {
                try settingsStorage.name?.write(to: settingsStorage.nameFileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            nameSaved = false
        }
        
        do {
            if bioDidChange {
                try settingsStorage.bio?.write(to: settingsStorage.bioFileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            bioSaved = false
        }
        
        do {
            if let data = settingsStorage.image?.jpegData(compressionQuality: 0.5),
                imageDidChange {
                try data.write(to: settingsStorage.imageFileURL)
            }
        } catch {
            imageSaved = false
        }
    }
}

// MARK: - ReadOperations
class ReadNameOperation: Operation {
    // MARK: - Dependencies
    var settingsStorage: ISettingsStorage

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
    
    override func main() {
        if isCancelled { return }
        do {
            if let name = try String(data: Data(contentsOf: settingsStorage.nameFileURL), encoding: .utf8) {
                settingsStorage.name = name
            }
        } catch {
            settingsStorage.name = "Marina Dudarenko"
        }
    }
}

class ReadBioOperation: Operation {
    // MARK: - Dependencies
    var settingsStorage: ISettingsStorage

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
    
    override func main() {
        if isCancelled { return }
        do {
            if let bio = try String(data: Data(contentsOf: settingsStorage.bioFileURL), encoding: .utf8) {
                settingsStorage.bio = bio
            }
        } catch {
            settingsStorage.bio = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
        }
    }
}

class ReadImageOperation: Operation {
    // MARK: - Dependencies
    var settingsStorage: ISettingsStorage

    // MARK: - Init / deinit
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
    
    override func main() {
        if isCancelled { return }
        do {
            if let image = try UIImage(data: Data(contentsOf: settingsStorage.imageFileURL)) {
                settingsStorage.image = image
            }
        } catch {
            settingsStorage.image = nil
        }
    }
}
