//
//  Colors.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Colors {
    static let profileImageGreen = UIColor(hexString: "#E4E82B")
    static let lettersLabelColor = UIColor(hexString: "#363738")
    
    static let onlineIndicatorGreen = UIColor(hexString: "#5AD439")
    static let settingsIconColor = UIColor(hexString: "#545458", alpha: 0.65)
    
    static let messageLabelLightColor = UIColor(hexString: "#3C3C43", alpha: 0.6)
    static let messageLabelDarkColor = UIColor(hexString: "#8D8D93")

    static let darkBlue = UIColor(hexString: "#193661")
    static let darkGreen = UIColor(hexString: "#0A4B46")
    static let darkGray = UIColor(hexString: "#545458", alpha: 0.65)
    
    static let lightBarColor = UIColor(hexString: "#F5F5F5")
    static let darkBarColor = UIColor(hexString: "#1E1E1E")
    
    static let timeLightGrayColor = UIColor(hexString: "#000000", alpha: 0.25)
    static let timeGrayColor = UIColor(hexString: "#ABABAB")
    static let timeWhiteColor = UIColor.white
    
    static let inputGray = UIColor(hexString: "#DFDFDF")
    static let inputLightGray = UIColor(hexString: "#EAEBED")
    static let inputDarkGray = UIColor(hexString: "#2E2E2E")
    
    static let outputGreen = UIColor(hexString: "#DCF7C5")
    static let outputBlue = UIColor(hexString: "#4389F9")
    static let outputDarkGray = UIColor(hexString: "#5C5C5C")
    
    static let saveButtonLightColor = UIColor(hexString: "#F6F6F6")
    static let saveButtonDarkColor = UIColor(hexString: "#1B1B1B")
    
    static let textFieldLightBackgroundColor = UIColor.white
    static let textFieldDarkBackgroundColor = UIColor(hexString: "#3B3B3B")
    
    static let textFieldLightTextColor = UIColor(hexString: "#8E8E93")
    static let textFieldDarkTextColor = UIColor(hexString: "#999999")
    
    static let searchBarLightColor = UIColor.black.withAlphaComponent(0.05)
    static let searchBarDarkColor = UIColor(hexString: "#F5F5F5")
    
    static let tableViewHeaderTextLightColor = UIColor.lightGray
    static let tableViewHeaderTextDarkColor = UIColor(hexString: "#E8E9ED")
    
    static let tableViewHeaderLightColor = UIColor.white.withAlphaComponent(0.85)
    static let tableViewHeaderDarkColor = UIColor.black.withAlphaComponent(0.85)

    static let separatorColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor.gray
        }
    }
    static let tableViewLightSeparatorColor = UIColor.lightGray
    
    static let alertDarkColor = UIColor(hexString: "#1E1E1E", alpha: 0.75)
    static let alertLightColor = UIColor.white
    
    static let classicAndDayButtonColor = UIColor.white
    static let nightButtonColor = UIColor(hexString: "#060606")
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
