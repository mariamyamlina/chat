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

    init() {
        OperationDataManager.profileViewController?.delegate = self
    }
    
    func writeToFile(nameText: String?, bioText: String?, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
        ProfileViewController.name = nameText
        ProfileViewController.bio = bioText
        ProfileViewController.image = image
        
        OperationDataManager.profileViewController?.editProfileButton.isEnabled = false
        OperationDataManager.profileViewController?.activityIndicator.startAnimating()
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let writeOperation = WriteOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateViewOperation()
        
        uiOperation.addDependency(writeOperation)
        operationQueue.addOperations([writeOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
    
    func readFromFile(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool) {
        
    }
    
    func readNameFromFile() {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let readOperation = ReadNameOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateNameOperation()
        
        uiOperation.addDependency(readOperation)
        operationQueue.addOperations([readOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
    
    func readBioFromFile() {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let readOperation = ReadBioOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateBioOperation()
        
        uiOperation.addDependency(readOperation)
        operationQueue.addOperations([readOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
    
    func readImageFromFile() {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let readOperation = ReadImageOperation()
        
        let mainOperationQueue = OperationQueue.main
        let uiOperation = UpdateImageOperation()
        
        uiOperation.addDependency(readOperation)
        operationQueue.addOperations([readOperation], waitUntilFinished: true)
        mainOperationQueue.addOperation(uiOperation)
    }
}
