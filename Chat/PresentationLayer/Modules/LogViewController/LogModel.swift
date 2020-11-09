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
}

class LogModel: LogModelProtocol {
    let loger: LogerProtocol
    
    init(loger: LogerProtocol) {
        self.loger = loger
    }
    
    func printLog(_ message: String, _ function: String) {
        loger.printVCLog(message, function)
    }
}
