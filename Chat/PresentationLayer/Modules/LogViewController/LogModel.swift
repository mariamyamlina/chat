//
//  LogModel.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ILogModel: class {
    func printLog(_ message: String, _ function: String)
    var currentTheme: Theme { get }
}

class LogModel {
    // MARK: - Dependencies
    let loger: ILoger
    let settingsService: ISettingsService
    
    // MARK: - Init / deinit
    init(loger: ILoger, settingsService: ISettingsService) {
        self.loger = loger
        self.settingsService = settingsService
    }
    
    var currentTheme: Theme {
        return settingsService.currentTheme
    }
}

// MARK: - ILogModel
extension LogModel: ILogModel {
    func printLog(_ message: String, _ function: String) {
        loger.printVCLog(message, function)
    }
}
