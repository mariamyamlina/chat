//
//  LogModel.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol LogModelProtocol: class {
    func printLog(_ message: String, _ function: String)
    var currentTheme: Theme { get }
}

class LogModel {
    // MARK: - Dependencies
    let loger: LogerProtocol
    let settingsService: SettingsServiceProtocol
    
    // MARK: - Init / deinit
    init(loger: LogerProtocol, settingsService: SettingsServiceProtocol) {
        self.loger = loger
        self.settingsService = settingsService
    }
    
    var currentTheme: Theme {
        return settingsService.currentTheme
    }
}

// MARK: - LogModelProtocol
extension LogModel: LogModelProtocol {
    func printLog(_ message: String, _ function: String) {
        loger.printVCLog(message, function)
    }
}
