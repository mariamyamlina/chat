//
//  LogViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 19.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    // MARK: - Dependencies
    private let model: LogModelProtocol
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: LogModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.printLog("ViewController is about to move from 'disappearing'/'disappeared' to 'appearing': \n", #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.printLog("ViewController moved from 'appearing' to 'appeared': \n", #function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        model.printLog("ViewController's view is about to layout its subviews: \n", #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        model.printLog("ViewController's view has just laid out its subviews: \n", #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.printLog("ViewController is about to move from 'appearing'/'appeared' to 'disappearing': \n", #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.printLog("ViewController moved from 'disappearing' to 'disappeared': \n", #function)
    }
}

// MARK: - LogAlert
extension LogViewController {
    func configureLogAlert(withTitle title: String? = nil, withMessage message: String? = nil) {
        let alertController = UIAlertController(title: (title ?? "") + " Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Settings.currentTheme.themeSettings
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
