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
    
    let notRun = "not running state"
    let fore = "foreground"
    let inAct = "inactive state"
    let act = "active state"
    let back = "background"
    let susp = "suspended state"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if AppDelegate.appLogIndicator {
            print("Application moved from \(notRun) to \(inAct): \(#function)")
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application moved from \(inAct) to \(act): \(#function)")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application moved from \(act) to \(inAct): \(#function)")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application moved from \(back) to \(inAct): \(#function)")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application moved from \(inAct) to \(back): \(#function)")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if AppDelegate.appLogIndicator {
            print("Application is about to terminate: \(#function)")
        }
    }

}

