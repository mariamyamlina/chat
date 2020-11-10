//
//  Extensions.swift
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
    
    func generateImage() -> UIImage? {
        let randNum = Int(arc4random_uniform(15))
        let image: UIImage?
        switch randNum {
        case 0:
            image = UIImage(named: "Butters")
        case 1:
            image = UIImage(named: "Chef")
        case 2:
            image = UIImage(named: "Craig")
        case 3:
            image = UIImage(named: "Eric")
        case 4:
            image = UIImage(named: "Ike")
        case 5:
            image = UIImage(named: "Jimmy")
        case 6:
            image = UIImage(named: "Kenny")
        case 7:
            image = UIImage(named: "Kyle")
        case 8:
            image = UIImage(named: "Lien")
        case 9:
            image = UIImage(named: "Randy")
        case 10:
            image = UIImage(named: "Sheila")
        case 11:
            image = UIImage(named: "Sheron")
        case 12:
            image = UIImage(named: "Stan")
        case 13:
            image = UIImage(named: "Timmy")
        case 14:
            image = UIImage(named: "Token")
        case 15:
            image = UIImage(named: "Wendy")
        default:
            image = nil
        }
        return image
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

extension String {
    func containtsOnlyOfWhitespaces() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Date {
    func dateFormatter(onlyTimeMode timeMode: Bool) -> String {
        let formatter = DateFormatter()
        if self.isToday() || timeMode {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        return formatter.string(from: self)
    }

    func isToday() -> Bool {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self) == formatter.string(from: today)
    }
}
