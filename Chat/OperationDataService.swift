//
//  OperationDataService.swift
//  Chat
//
//  Created by Maria Myamlina on 09.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class OperationDataService: DataService {
    private let operationQueue = OperationQueue()
    private let mainOperationQueue = OperationQueue.main
}

extension OperationDataService: DataServiceProtocol {
    func saveToFile(completion: @escaping (Bool) -> Void) {
        let writeOperation = WriteOperation()
        let completionOperation = BlockOperation {
            let result = writeOperation.nameSaved && writeOperation.bioSaved && writeOperation.imageSaved
            completion(result)
        }
        
        completionOperation.addDependency(writeOperation)
        operationQueue.addOperations([writeOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(completionOperation)
    }
    
    func loadFromFile(mustReadName: Bool = true, mustReadBio: Bool = true, mustReadImage: Bool = true, completion: @escaping (Bool, Bool, Bool) -> Void) {
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
