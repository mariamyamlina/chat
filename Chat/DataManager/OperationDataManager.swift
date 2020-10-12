//
//  OperationDataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class OperationDataManager: DataManagerDelegate {
    static var profileViewController: ProfileViewController?
    
    private let operationQueue = OperationQueue()
    private let mainOperationQueue = OperationQueue.main

    init() {
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
        
        OperationDataManager.profileViewController?.delegate = self
    }
    
    func writeToFile(completion: @escaping (Bool) -> Void) {
        let writeOperation = WriteOperation()        
        let completionOperation = BlockOperation {
            completion(writeOperation.hasSucceeded)
        }
        
        completionOperation.addDependency(writeOperation)
        operationQueue.addOperations([writeOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(completionOperation)
    }
    //Не работает
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
//        operationQueue.addOperation(readBioOperation)
//        operationQueue.addOperation(readImageOperation)
    }
}
