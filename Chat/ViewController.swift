//
//  ViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 11.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from disappeared to appearing: \(#function)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from appearing to appeared: \(#function)")
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if AppDelegate.appLogIndicator {
            print("ViewController's view is about to layout its subviews: \(#function)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if AppDelegate.appLogIndicator {
            print("ViewController's view has just laid out its subviews: \(#function)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from appearing/appeared to disappearing: \(#function)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.appLogIndicator {
            print("ViewController moved from disappearing to disappeared/appearing: \(#function)")
        }
    }
}

