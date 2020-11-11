//
//  UIViewController + Extension.swift
//  Chat
//
//  Created by Maria Myamlina on 09.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: self)
        return navigationVC
    }
}
