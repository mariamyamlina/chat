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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from \(disappEd) to \(appIng): \n" + "called \(#function)\n")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from \(appIng) to \(appEd): \n" + "called \(#function)\n")
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if AppDelegate.appLogIndicator {
            print("ViewController's view is about to layout its subviews: \n" + "called \(#function)\n")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if AppDelegate.appLogIndicator {
            print("ViewController's view has just laid out its subviews: \n" + "called \(#function)\n")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from \(appIng)/\(appEd) to \(disappIng): \n" + "called \(#function)\n")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from \(disappIng) to \(disappEd)/\(appIng): \n" + "called \(#function)\n")
        }
    }
}

