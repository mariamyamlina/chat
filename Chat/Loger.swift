//
//  Loger.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class Loger {
    static let appLogIndicator = false
    static let vcLogIndicator = false
    static let buttonLogIndicator = false
    static let dbLogIndicator = false
    
    static var printAppLog = {(message: String, current: UIApplication.State, function: String) in
        if Loger.appLogIndicator {
            var currentState: (UIApplication.State) -> Void = { state in
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
            print(message)
            currentState(current)
            print("called method - \(function)\n")
        }
    }
    
    static var printVCLog = {(message: String, function: String) in
        if Loger.vcLogIndicator {
            print(message + "called method - \(function)\n")
        }
    }
    
    static var printButtonLog = {(button: UIButton, function: String) in
        if Loger.buttonLogIndicator {
            print("Button frame from \(function):\n\(button.frame)\n")
        }
    }
    
    static var printDBLog = {(modificationType: String, count: Int) in
        if Loger.dbLogIndicator {
            print(modificationType + " objects count: \(count)")
        }
    }
    
    static var printDBStatLog = {(channelsCount: Int, messagesCount: Int, infoAbout: [String]) in
        if Loger.dbLogIndicator {
            var channelsCounter = 0
            print("Total \(channelsCount) channels and \(messagesCount) messages")
            for info in infoAbout {
                channelsCounter += 1
                print("\(channelsCounter). " + info)
            }
        }
    }
}