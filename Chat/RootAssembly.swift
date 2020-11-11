//
//  RootAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol LogerAssemblyProtocol {
    var loger: LogerProtocol { get }
}

protocol CoreDataStackAssemblyProtocol {
    var coreDataStack: CoreDataStackProtocol { get }
}

protocol ThemeStorageAssemblyProtocol {
    var themeStorage: ThemeStorageProtocol { get }
}

class RootAssembly {
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: ServicesAssemblyProtocol = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}

extension RootAssembly: LogerAssemblyProtocol {
    var loger: LogerProtocol { return serviceAssembly.loger }
}

extension RootAssembly: CoreDataStackAssemblyProtocol {
    var coreDataStack: CoreDataStackProtocol { return coreAssembly.coreDataStack }
}

extension RootAssembly: ThemeStorageAssemblyProtocol {
    var themeStorage: ThemeStorageProtocol { return coreAssembly.themeStorage }
}
