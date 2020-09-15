//
//  AppDelegate.swift
//  Chat
//
//  Created by Maria Myamlina on 11.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

//@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Индикатор наличия логов приложения
    static let appLogIndicator = true
    
    let notRun = "'not running state'"
    let fore = "'foreground'"
    let inAct = "'inactive state'"
    let act = "'active state'"
    let back = "'background'"
    
    lazy var currentState: (UIApplication.State) -> () = { state in
        switch state.rawValue {
        case 0:
            print("current - \(self.act),")
        case 1:
            print("current - \(self.inAct),")
        case 2:
            print("current - \(self.back),")
        default:
            break
        }
    }
    
    private func printLog(message: String, current: UIApplication.State, function: String = #function) {
        if AppDelegate.appLogIndicator {
            print(message)
            currentState(current)
            print("called method - \(function)\n")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        printLog(message: "Application moved from \(notRun) to \(inAct):", current: application.applicationState)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printLog(message: "Application moved from \(inAct) to \(act):", current: application.applicationState)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        printLog(message: "Application is about to move from \(act) to \(inAct):", current: application.applicationState)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printLog(message: "Application is about to move from \(back) to \(inAct):", current: application.applicationState)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printLog(message: "Application moved from \(inAct) to \(back):", current: application.applicationState)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printLog(message: "Application is about to terminate:", current: application.applicationState)
    }

}

