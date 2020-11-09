//
//  CoreAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var gcdDataManager: DataManagerProtocol { get }
    var operationDataManager: DataManagerProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var gcdDataManager: DataManagerProtocol = GCDDataManager()
    lazy var operationDataManager: DataManagerProtocol = OperationDataManager()
}
