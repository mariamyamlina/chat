//
//  OperationDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class OperationDataManager: DataManager {
    private let operationQueue = OperationQueue()
    private let mainOperationQueue = OperationQueue.main
    
    // MARK: - Singleton
    
    static var shared: OperationDataManager = {
        return OperationDataManager()
    }()
    private override init() { }
}

extension OperationDataManager: DataManagerProtocol {
    func writeToFile(completion: @escaping (Result) -> Void) {
        let writeOperation = WriteOperation()
        let completionOperation = BlockOperation {
            let succeeded: Result
            if writeOperation.nameSaved && writeOperation.bioSaved && writeOperation.imageSaved {
                succeeded = .success
            } else {
                succeeded = .error
            }
            completion(succeeded)
        }
        
        completionOperation.addDependency(writeOperation)
        operationQueue.addOperations([writeOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(completionOperation)
    }
    
    func readFromFile(mustReadName: Bool = true, mustReadBio: Bool = true, mustReadImage: Bool = true, completion: @escaping (Bool, Bool, Bool) -> Void) {
        let readNameOperation = ReadNameOperation()
        let readBioOperation = ReadBioOperation()
        let readImageOperation = ReadImageOperation()
        let completionOperation = BlockOperation {
            completion(mustReadName, mustReadBio, mustReadImage)
        }

        completionOperation.addDependency(readNameOperation)
        completionOperation.addDependency(readBioOperation)
        completionOperation.addDependency(readImageOperation)
        operationQueue.addOperations([readNameOperation, readBioOperation, readImageOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(completionOperation)
    }
}
