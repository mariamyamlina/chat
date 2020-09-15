//
//  ViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 11.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let appIng = "'appearing'"
    let appEd = "'appeared'"
    let disappIng = "'disappearing'"
    let disappEd = "'disappeared'"
    
    private func printLog(message: String, function: String = #function) {
        if AppDelegate.appLogIndicator {
            print(message + "called method - \(function)\n")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog(message: "ViewController is about to move from \(disappIng)/\(disappEd) to \(appIng): \n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLog(message: "ViewController moved from \(appIng) to \(appEd): \n")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLog(message: "ViewController's view is about to layout its subviews: \n")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLog(message: "ViewController's view has just laid out its subviews: \n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLog(message: "ViewController is about to move from \(appIng)/\(appEd) to \(disappIng): \n")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLog(message: "ViewController moved from \(disappIng) to \(disappEd): \n")
    }
}

