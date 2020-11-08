//
//  ThemesSet.swift
//  Chat
//
//  Created by Maria Myamlina on 02.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct ClassicTheme: ThemeOptionsProtocol {
    var inputBubbleColor: UIColor { return Colors.inputGray }
    var outputBubbleColor: UIColor { return Colors.outputGreen }
    var messageLabelColor: UIColor { return Colors.messageLabelLightColor }
    
    var textColor: UIColor { return .black }
    var outputTextColor: UIColor { return .black }
    
    var barColor: UIColor { return Colors.lightBarColor }
    var alertColor: UIColor { return Colors.alertLightColor }
    var saveButtonColor: UIColor { return Colors.saveButtonLightColor }
    var backgroundColor: UIColor { return .white }
    var settingsBackgroundColor: UIColor { return Colors.darkGreen }
    
    var inputTimeColor: UIColor { return Colors.timeLightGrayColor }
    var outputTimeColor: UIColor { return Colors.timeLightGrayColor }
    
    var textFieldBackgroundColor: UIColor { return Colors.textFieldLightBackgroundColor }
    var textFieldTextColor: UIColor { return Colors.textFieldLightTextColor }
    var searchBarTextColor: UIColor { return Colors.searchBarLightTextColor }
    
    var barStyle: UIBarStyle { return .default }
    var keyboardAppearance: UIKeyboardAppearance { return .default }
    
    var tableViewSeparatorColor: UIColor { return Colors.tableViewLightSeparatorColor }
    var tableViewHeaderTextColor: UIColor { return Colors.tableViewHeaderTextLightColor }
    var tableViewHeaderColor: UIColor { return Colors.tableViewHeaderLightColor }
}

struct DayTheme: ThemeOptionsProtocol {
    var inputBubbleColor: UIColor { return Colors.inputLightGray }
    var outputBubbleColor: UIColor { return Colors.outputBlue }
    var messageLabelColor: UIColor { return Colors.messageLabelLightColor }
    
    var textColor: UIColor { return .black }
    var outputTextColor: UIColor { return .white }
    
    var barColor: UIColor { return Colors.lightBarColor }
    var alertColor: UIColor { return Colors.alertLightColor }
    var saveButtonColor: UIColor { return Colors.saveButtonLightColor }
    var backgroundColor: UIColor { return .white }
    var settingsBackgroundColor: UIColor { return Colors.darkBlue }
    
    var inputTimeColor: UIColor { return Colors.timeGrayColor }
    var outputTimeColor: UIColor { return Colors.timeWhiteColor }
    
    var textFieldBackgroundColor: UIColor { return Colors.textFieldLightBackgroundColor }
    var textFieldTextColor: UIColor { return Colors.textFieldLightTextColor }
    var searchBarTextColor: UIColor { return Colors.searchBarLightTextColor }
    
    var barStyle: UIBarStyle { return .default }
    var keyboardAppearance: UIKeyboardAppearance { return .default }
    
    var tableViewSeparatorColor: UIColor { return Colors.tableViewLightSeparatorColor }
    var tableViewHeaderTextColor: UIColor { return Colors.tableViewHeaderTextLightColor }
    var tableViewHeaderColor: UIColor { return Colors.tableViewHeaderLightColor }
}

struct NightTheme: ThemeOptionsProtocol {
    var inputBubbleColor: UIColor { return Colors.inputDarkGray }
    var outputBubbleColor: UIColor { return Colors.outputDarkGray }
    var messageLabelColor: UIColor { return Colors.messageLabelDarkColor }
    
    var textColor: UIColor { return .white }
    var outputTextColor: UIColor { return .white }
    
    var barColor: UIColor { return Colors.darkBarColor }
    var alertColor: UIColor { return Colors.alertDarkColor }
    var saveButtonColor: UIColor { return Colors.saveButtonDarkColor }
    var backgroundColor: UIColor { return .black }
    var settingsBackgroundColor: UIColor { return Colors.darkGray }
    
    var inputTimeColor: UIColor { return Colors.timeWhiteColor }
    var outputTimeColor: UIColor { return Colors.timeWhiteColor }
    
    var textFieldBackgroundColor: UIColor { return Colors.textFieldDarkBackgroundColor }
    var textFieldTextColor: UIColor { return Colors.textFieldDarkTextColor }
    var searchBarTextColor: UIColor { return Colors.searchBarDarkTextColor }
    
    var barStyle: UIBarStyle { return .black }
    var keyboardAppearance: UIKeyboardAppearance { return .dark }
    
    var tableViewSeparatorColor: UIColor { return Colors.separatorColor() }
    var tableViewHeaderTextColor: UIColor { return Colors.tableViewHeaderTextDarkColor }
    var tableViewHeaderColor: UIColor { return Colors.tableViewHeaderDarkColor }
}
