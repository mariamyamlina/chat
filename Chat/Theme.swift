//
//  Theme.swift
//  Chat
//
//  Created by Maria Myamlina on 05.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

// MARK: - Colors

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


// MARK: - Theme

enum Theme: Int, CaseIterable {
    case classic = 0
    case day
    case night

    var themeOptions: ThemeOptions {
        get {
            switch self {
            case .classic:
                return ClassicTheme()
            case .day:
                return DayTheme()
            case .night:
                return NightTheme()
            }
        }
        set { }
    }
}

extension Theme {

    @Persist(key: "app_theme", defaultValue: Theme.classic.rawValue)
    private static var appTheme: Int

    func save() {
        Theme.appTheme = self.rawValue
    }

    static var current: Theme {
        get { return Theme(rawValue: appTheme) ?? .classic }
        set { }
    }

    @available(iOS 13.0, *)
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .classic: return .light
        case .day: return .light
        case .night: return .dark
        }
    }

    func setActive() {
        save()

        guard #available(iOS 13.0, *) else { return }

        UIApplication.shared.windows
            .forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
    }
}

@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}


// MARK: - ThemeOptions

protocol ThemeOptions {
    var inputBubbleColor: UIColor { get }
    var outputBubbleColor: UIColor { get }
    
    var inputAndCommonTextColor: UIColor { get }
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
}

struct ClassicTheme: ThemeOptions {
    var inputBubbleColor: UIColor { return Colors.inputGrey }
    var outputBubbleColor: UIColor { return Colors.outputGreen }
    
    var inputAndCommonTextColor: UIColor { return .black }
    var outputTextColor: UIColor { return .black }
    
    var barColor: UIColor { return Colors.lightBarColor }
    var alertColor: UIColor { return Colors.alertLightColor }
    var saveButtonColor: UIColor { return Colors.saveButtonLightColor }
    var backgroundColor: UIColor { return .white }
    var settingsBackgroundColor: UIColor { return Colors.darkGreen }
    
    var inputTimeColor: UIColor { return Colors.timeGreyColor }
    var outputTimeColor: UIColor { return Colors.timeGreyColor }
    
    var textFieldBackgroundColor: UIColor { return Colors.textFieldLightBackgroundColor }
    var textFieldTextColor: UIColor { return Colors.textFieldLightTextColor }
    var searchBarTextColor: UIColor { return Colors.searchBarLightTextColor }
    
    var barStyle: UIBarStyle { return .default }
    var keyboardAppearance: UIKeyboardAppearance { return .default }
    
    var tableViewSeparatorColor: UIColor { return Colors.tableViewLightSeparatorColor }
}

struct DayTheme: ThemeOptions {
    var inputBubbleColor: UIColor { return Colors.inputLightGrey }
    var outputBubbleColor: UIColor { return Colors.outputBlue }
    
    var inputAndCommonTextColor: UIColor { return .black }
    var outputTextColor: UIColor { return .white }
    
    var barColor: UIColor { return Colors.lightBarColor }
    var alertColor: UIColor { return Colors.alertLightColor }
    var saveButtonColor: UIColor { return Colors.saveButtonLightColor }
    var backgroundColor: UIColor { return .white }
    var settingsBackgroundColor: UIColor { return Colors.darkBlue }
    
    var inputTimeColor: UIColor { return Colors.timeGreyColor }
    var outputTimeColor: UIColor { return Colors.timeWhiteColor }
    
    var textFieldBackgroundColor: UIColor { return Colors.textFieldLightBackgroundColor }
    var textFieldTextColor: UIColor { return Colors.textFieldLightTextColor }
    var searchBarTextColor: UIColor { return Colors.searchBarLightTextColor }
    
    var barStyle: UIBarStyle { return .default }
    var keyboardAppearance: UIKeyboardAppearance { return .default }
    
    var tableViewSeparatorColor: UIColor { return Colors.tableViewLightSeparatorColor }
}

struct NightTheme: ThemeOptions {
    var inputBubbleColor: UIColor { return Colors.inputDarkGrey }
    var outputBubbleColor: UIColor { return Colors.outputDarkGrey }
    
    var inputAndCommonTextColor: UIColor { return .white }
    var outputTextColor: UIColor { return .white }
    
    var barColor: UIColor { return Colors.darkBarColor }
    var alertColor: UIColor { return Colors.alertDarkColor }
    var saveButtonColor: UIColor { return Colors.saveButtonDarkColor }
    var backgroundColor: UIColor { return .black }
    var settingsBackgroundColor: UIColor { return Colors.darkGrey }
    
    var inputTimeColor: UIColor { return Colors.timeWhiteColor }
    var outputTimeColor: UIColor { return Colors.timeWhiteColor }
    
    var textFieldBackgroundColor: UIColor { return Colors.textFieldDarkBackgroundColor }
    var textFieldTextColor: UIColor { return Colors.textFieldDarkTextColor }
    var searchBarTextColor: UIColor { return Colors.searchBarDarkTextColor }
    
    var barStyle: UIBarStyle { return .black }
    var keyboardAppearance: UIKeyboardAppearance { return .dark }
    
    var tableViewSeparatorColor: UIColor { return Colors.separatorColor() }
}

