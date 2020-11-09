//
//  ViewControllerExtension.swift
//  Chat
//
//  Created by Maria Myamlina on 09.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: self)
        navigationVC.applyTheme()
        return navigationVC
    }
}

extension UINavigationController {
    func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        if #available(iOS 13.0, *) { } else {
            self.navigationBar.barTintColor = currentTheme.barColor
            self.navigationBar.barStyle = currentTheme.barStyle
        }
    }
}
