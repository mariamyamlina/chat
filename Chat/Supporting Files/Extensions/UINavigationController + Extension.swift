//
//  UINavigationController + Extension.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

extension UINavigationController {
    func applyTheme(theme: Theme) {
        if #available(iOS 13.0, *) { } else {
            self.navigationBar.barTintColor = theme.themeSettings.barColor
            self.navigationBar.barStyle = theme.themeSettings.barStyle
        }
    }
}
