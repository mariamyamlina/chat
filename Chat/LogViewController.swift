//
//  LogViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 19.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loger.printVCLog("ViewController is about to move from 'disappearing'/'disappeared' to 'appearing': \n", #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loger.printVCLog("ViewController moved from 'appearing' to 'appeared': \n", #function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Loger.printVCLog("ViewController's view is about to layout its subviews: \n", #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Loger.printVCLog("ViewController's view has just laid out its subviews: \n", #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Loger.printVCLog("ViewController is about to move from 'appearing'/'appeared' to 'disappearing': \n", #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Loger.printVCLog("ViewController moved from 'disappearing' to 'disappeared': \n", #function)
    }
}

extension LogViewController {
    func configureLogAlert(withTitle title: String? = nil, withMessage message: String? = nil) {
        let alertController = UIAlertController(title: (title ?? "") + " Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
