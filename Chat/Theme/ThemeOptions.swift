//
//  ThemeOptions.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ThemeOptions {
    var inputBubbleColor: UIColor { get }
    var outputBubbleColor: UIColor { get }
    
    var textColor: UIColor { get }
    var outputTextColor: UIColor { get }
    
    var barColor: UIColor { get }
    var alertColor: UIColor { get }
    var saveButtonColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var settingsBackgroundColor: UIColor { get }
    
    var inputTimeColor: UIColor { get }
    var outputTimeColor: UIColor { get }
    
    var textFieldBackgroundColor: UIColor { get }
    var textFieldTextColor: UIColor { get }
    var searchBarTextColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    
    var tableViewSeparatorColor: UIColor { get }
    var tableViewHeaderTextColor: UIColor { get }
    var tableViewHeaderColor: UIColor { get }
}

// MARK: - Theme Set

struct ClassicTheme: ThemeOptions {
    var inputBubbleColor: UIColor { return Colors.inputGray }
    var outputBubbleColor: UIColor { return Colors.outputGreen }
    
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

struct DayTheme: ThemeOptions {
    var inputBubbleColor: UIColor { return Colors.inputLightGray }
    var outputBubbleColor: UIColor { return Colors.outputBlue }
    
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

struct NightTheme: ThemeOptions {
    var inputBubbleColor: UIColor { return Colors.inputDarkGray }
    var outputBubbleColor: UIColor { return Colors.outputDarkGray }
    
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
