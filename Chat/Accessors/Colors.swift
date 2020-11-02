//
//  Colors.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Colors {
    static let profileImageGreen = UIColor(red: 228 / 250, green: 232 / 250, blue: 43 / 250, alpha: 1)
    static let lettersLabelColor = UIColor(red: 54 / 250, green: 55 / 250, blue: 56 / 250, alpha: 1)
    static let onlineIndicatorGreen = UIColor(red: 90 / 250, green: 212 / 250, blue: 57 / 250, alpha: 1)
    
    static let messageLabelLightColor = UIColor(red: 60 / 250, green: 60 / 250, blue: 67 / 250, alpha: 0.6)
    static let messageLabelDarkColor = UIColor(red: 141 / 250, green: 141 / 250, blue: 147 / 250, alpha: 1)
    
    static let settingsIconColor = UIColor(red: 84 / 250, green: 84 / 250, blue: 88 / 250, alpha: 0.65)

    static let darkBlue = UIColor(red: 25 / 250, green: 54 / 250, blue: 97 / 250, alpha: 1)
    static let darkGreen = UIColor(red: 10 / 250, green: 75 / 250, blue: 70 / 250, alpha: 1)
    static let darkGray = UIColor(red: 84 / 250, green: 84 / 250, blue: 88 / 250, alpha: 0.65)
    
    static let lightBarColor = UIColor(red: 245 / 250, green: 245 / 250, blue: 245 / 250, alpha: 1.0)
    static let darkBarColor = UIColor.black
    
    static let timeLightGrayColor = UIColor(red: 0 / 250, green: 0 / 250, blue: 0 / 250, alpha: 0.25)
    static let timeGrayColor = UIColor(red: 171 / 250, green: 171 / 250, blue: 171 / 250, alpha: 1)
    static let timeWhiteColor = UIColor.white
    
    static let inputGray = UIColor(red: 223 / 250, green: 223 / 250, blue: 223 / 250, alpha: 1)
    static let inputLightGray = UIColor(red: 234 / 250, green: 235 / 250, blue: 237 / 250, alpha: 1)
    static let inputDarkGray = UIColor(red: 46 / 250, green: 46 / 250, blue: 46 / 250, alpha: 1)
    
    static let outputGreen = UIColor(red: 220 / 250, green: 247 / 250, blue: 197 / 250, alpha: 1)
    static let outputBlue = UIColor(red: 67 / 250, green: 137 / 250, blue: 249 / 250, alpha: 1)
    static let outputDarkGray = UIColor(red: 92 / 250, green: 92 / 250, blue: 92 / 250, alpha: 1)
    
    static let saveButtonLightColor = UIColor(red: 246 / 250, green: 246 / 250, blue: 246 / 250, alpha: 1)
    static let saveButtonDarkColor = UIColor(red: 27 / 250, green: 27 / 250, blue: 27 / 250, alpha: 1)
    
    static let textFieldDarkBackgroundColor = UIColor(red: 59 / 250, green: 59 / 250, blue: 59 / 250, alpha: 1)
    static let textFieldLightBackgroundColor = UIColor.white
    
    static let textFieldLightTextColor = UIColor(red: 142 / 250, green: 142 / 250, blue: 147 / 250, alpha: 1)
    static let textFieldDarkTextColor = UIColor(red: 153 / 250, green: 153 / 250, blue: 153 / 250, alpha: 1)
    
    static let searchBarLightTextColor = UIColor(red: 0 / 250, green: 0 / 250, blue: 0 / 250, alpha: 0.05)
    static let searchBarDarkTextColor = UIColor(red: 245 / 250, green: 245 / 250, blue: 245 / 250, alpha: 1)
    
    static let tableViewHeaderTextLightColor = UIColor.lightGray
    static let tableViewHeaderTextDarkColor = UIColor(red: 232 / 255, green: 233 / 255, blue: 237 / 255, alpha: 1)
    
    static let tableViewHeaderLightColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.85)
    static let tableViewHeaderDarkColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.85)

    static let separatorColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor.gray
        }
    }
    static let tableViewLightSeparatorColor = UIColor.lightGray
    
    static let alertDarkColor = UIColor(red: 30 / 250, green: 30 / 250, blue: 30 / 250, alpha: 0.75)
    static let alertLightColor = UIColor.white
    
    static let classicAndDayButtonColor = UIColor.white
    static let nightButtonColor = UIColor(red: 6 / 250, green: 6 / 250, blue: 6 / 250, alpha: 1)
}
