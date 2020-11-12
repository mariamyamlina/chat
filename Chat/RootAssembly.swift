//
//  RootAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ILogerAssembly {
    var loger: ILoger { get }
}

protocol ICoreDataStackAssembly {
    var coreDataStack: ICoreDataStack { get }
}

protocol IThemeStorageAssembly {
    var themeStorage: IThemeStorage { get }
}

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}

extension RootAssembly: ILogerAssembly {
    var loger: ILoger { return serviceAssembly.loger }
}

extension RootAssembly: ICoreDataStackAssembly {
    var coreDataStack: ICoreDataStack { return coreAssembly.coreDataStack }
}

extension RootAssembly: IThemeStorageAssembly {
    var themeStorage: IThemeStorage { return coreAssembly.themeStorage }
}
