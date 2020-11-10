//
//  ServicesAssembly.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var firebaseService: FirebaseServiceProtocol { get }
    var themeService: ThemesServiceProtocol { get }
    func fetchService(with channel: Channel?) -> FetchServiceProtocol
    var dataService: DataServiceProtocol { get }
    var loger: LogerProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var firebaseService: FirebaseServiceProtocol = FirebaseService(firebaseManager: self.coreAssembly.firebaseManager, serviceAssembly: self)
    lazy var themeService: ThemesServiceProtocol = ThemesService()
    func fetchService(with channel: Channel? = nil) -> FetchServiceProtocol {
        return FetchService(channel: channel)
    }
    lazy var dataService: DataServiceProtocol = DataService(gcdDataManager: self.coreAssembly.gcdDataManager, operationDataManager: self.coreAssembly.operationDataManager)
    lazy var loger: LogerProtocol = Loger(coreDataStack: self.coreAssembly.coreDataStack)
    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(coreDataStack: self.coreAssembly.coreDataStack)
}
