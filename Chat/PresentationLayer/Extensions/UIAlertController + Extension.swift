//
//  UIAlertController + Extension.swift
//  Chat
//
//  Created by Maria Myamlina on 16.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
extension UIAlertController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        pruneNegativeWidthConstraints()
    }
    
    func pruneNegativeWidthConstraints() {
        for subview in self.view.subviews {
            for constraint in subview.constraints where constraint.debugDescription.contains("width == - 16") {
                subview.removeConstraint(constraint)
            }
        }
    }
    
    func applyTheme(theme: Theme) {
        if #available(iOS 13.0, *) { } else {
            if let subview = self.view.subviews.first?.subviews.first?.subviews.first {
                subview.backgroundColor = theme.settings.alertColor
            }
        }
    }
}
