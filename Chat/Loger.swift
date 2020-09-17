//
//  Loger.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class Loger: NSObject {
    
    //Индикатор наличия логов приложения
    static let appLogIndicator = true
    
    static var printAppLog = {(message: String, current: UIApplication.State, function: String) in
        
        var currentState: (UIApplication.State) -> () = { state in
            switch state.rawValue {
            case 0:
                print("current - 'active state',")
            case 1:
                print("current - 'inactive state',")
            case 2:
                print("current - 'background',")
            default:
                break
            }
        }
        
        if Loger.appLogIndicator {
            print(message)
            currentState(current)
            print("called method - \(function)\n")
        }
    }
    
    static var printVCLog = {(message: String, function: String) in
        if Loger.appLogIndicator {
            print(message + "called method - \(function)\n")
        }
    }
}
