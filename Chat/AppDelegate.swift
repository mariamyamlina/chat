//
//  AppDelegate.swift
//  Chat
//
//  Created by Maria Myamlina on 11.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

let themeWindow = UIWindow()

extension UIWindow {
    func initTheme() {
        guard #available(iOS 13.0, *) else { return }
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreDataStack = CoreDataStack.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Loger.printAppLog("Application moved from 'not running state' to 'inactive state':", application.applicationState, #function)
    
        Theme.current.setActive()
        themeWindow.initTheme()
        themeWindow.makeKey()
        
        FirebaseApp.configure()

        coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistics()
        }
        coreDataStack.enableObservers()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Loger.printAppLog("Application moved from 'inactive state' to 'active state':", application.applicationState, #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Loger.printAppLog("Application is about to move from 'active state' to 'inactive state':", application.applicationState, #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Loger.printAppLog("Application is about to move from 'background' to 'inactive state':", application.applicationState, #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Loger.printAppLog("Application moved from 'inactive state' to 'background':", application.applicationState, #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Loger.printAppLog("Application is about to terminate:", application.applicationState, #function)
    }

}
