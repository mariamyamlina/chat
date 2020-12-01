//
//  Loger.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ILoger {
    func printAppLog(_ message: String, _ current: UIApplication.State, _ function: String)
    func printVCLog(_ message: String, _ function: String)
    func printButtonLog(_ button: ButtonWithTouchSize, _ function: String)
    func printDBLog(_ modificationType: String, _ count: Int)
    func printDBStatLog(_ channelsCount: Int, _ messagesCount: Int, _ infoAbout: [String])
}

class Loger {
    var coreDataStack: ICoreDataStack
    let appLogIndicator = false
    let vcLogIndicator = false
    let buttonLogIndicator = false
    let dbLogIndicator = false
    
    // MARK: - Init / deinit
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
        self.coreDataStack.delegate = self
    }
}

// MARK: - ILoger
extension Loger: ILoger {
    func printAppLog(_ message: String, _ current: UIApplication.State, _ function: String) {
        if appLogIndicator {
            let currentState: (UIApplication.State) -> Void = { state in
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
    
    func printVCLog(_ message: String, _ function: String) {
        if vcLogIndicator {
            print(message + "called method - \(function)\n")
        }
    }
    
    func printButtonLog(_ button: ButtonWithTouchSize, _ function: String) {
        if buttonLogIndicator {
            print("Button frame from \(function):\n\(button.frame)\n")
        }
    }
    
    func printDBLog(_ modificationType: String, _ count: Int) {
        if dbLogIndicator {
            print(modificationType + " objects count: \(count)")
        }
    }
    
    func printDBStatLog(_ channelsCount: Int, _ messagesCount: Int, _ infoAbout: [String]) {
        if dbLogIndicator {
            var channelsCounter = 0
            print("Total \(channelsCount) channels and \(messagesCount) messages")
            for info in infoAbout {
                channelsCounter += 1
                print("\(channelsCounter). " + info)
            }
        }
    }
}

// MARK: - CoreDataStackDelegate
extension Loger: CoreDataStackDelegate {
    func printLog(_ modificationType: String, _ count: Int) {
        printDBLog(modificationType, count)
    }
    
    func printStatLog(_ channelsCount: Int, _ messagesCount: Int, _ infoAbout: [String]) {
        printDBStatLog(channelsCount, messagesCount, infoAbout)
    }
}
