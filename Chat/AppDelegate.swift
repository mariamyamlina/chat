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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if AppDelegate.appLogIndicator {
            print("Application moved from \(notRun) to \(inAct):")
            currentState(application.applicationState)
            print("called method - \(#function)\n")
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application moved from \(inAct) to \(act):")
            currentState(application.applicationState)
            print("called method - \(#function)\n")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application is about to move from \(act) to \(inAct):")
            currentState(application.applicationState)
            print("called method - \(#function)\n")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application is about to move from \(back) to \(inAct):")
            currentState(application.applicationState)
            print("called method - \(#function)\n")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application moved from \(inAct) to \(back):")
            currentState(application.applicationState)
            print("called method - \(#function)\n")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application is about to terminate:")
            currentState(application.applicationState)
            print("called method - \(#function)\n")
        }
    }

}

