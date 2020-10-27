//
//  Colors.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct Colors {
    static var lettersLabelColor = UIColor(red: 54/250, green: 55/250, blue: 56/250, alpha: 1)
    
    static var brightGreen = UIColor(red: 90/250, green: 212/250, blue: 57/250, alpha: 1)
    
    static var settingsIconColor = UIColor(red: 84/250, green: 84/250, blue: 88/250, alpha: 0.65)

    static var darkBlue = UIColor(red: 25/250, green: 54/250, blue: 97/250, alpha: 1)
    static var darkGreen = UIColor(red: 10/250, green: 75/250, blue: 70/250, alpha: 1)
    static var darkGrey = UIColor(red: 84/250, green: 84/250, blue: 88/250, alpha: 0.65)
    
    static var lightBarColor = UIColor(red: 245/250, green: 245/250, blue: 245/250, alpha: 1.0)
    static var darkBarColor = UIColor.black
    
    static var timeGreyColor = UIColor(red: 171, green: 171, blue: 171, alpha: 1)
    static var timeWhiteColor = UIColor.white
    
    static var inputGrey = UIColor(red: 223/250, green: 223/250, blue: 223/250, alpha: 1)
    static var inputLightGrey = UIColor(red: 234/250, green: 235/250, blue: 237/250, alpha: 1)
    static var inputDarkGrey = UIColor(red: 46/250, green: 46/250, blue: 46/250, alpha: 1)
    
    static var outputGreen = UIColor(red: 220/250, green: 247/250, blue: 197/250, alpha: 1)
    static var outputBlue = UIColor(red: 67/250, green: 137/250, blue: 249/250, alpha: 1)
    static var outputDarkGrey = UIColor(red: 92/250, green: 92/250, blue: 92/250, alpha: 1)
    
    static var saveButtonLightColor = UIColor(red: 246/250, green: 246/250, blue: 246/250, alpha: 1)
    static var saveButtonDarkColor = UIColor(red: 27/250, green: 27/250, blue: 27/250, alpha: 1)
    
    static var textFieldDarkBackgroundColor = UIColor(red: 59/250, green: 59/250, blue: 59/250, alpha: 1)
    static var textFieldLightBackgroundColor = UIColor.white
    
    static var textFieldLightTextColor = UIColor(red: 142/250, green: 142/250, blue: 147/250, alpha: 1)
    static var textFieldDarkTextColor = UIColor(red: 153/250, green: 153/250, blue: 153/250, alpha: 1)
    
    static var searchBarLightTextColor = UIColor(red: 0/250, green: 0/250, blue: 0/250, alpha: 0.05)
    static var searchBarDarkTextColor = UIColor(red: 245/250, green: 245/250, blue: 245/250, alpha: 1)

    static var separatorColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor.gray
        }
    }
    static var tableViewLightSeparatorColor = UIColor.lightGray
    
    static var alertDarkColor = UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 0.75)
    static var alertLightColor = UIColor.white
}
