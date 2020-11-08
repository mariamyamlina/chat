//
//  Theme.swift
//  Chat
//
//  Created by Maria Myamlina on 05.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

enum Theme: Int, CaseIterable {
    case classic = 0
    case day
    case night

    var themeOptions: ThemeOptionsProtocol {
        switch self {
        case .classic:
            return ClassicTheme()
        case .day:
            return DayTheme()
        case .night:
            return NightTheme()
        }
    }
}

extension Theme {
    @Persist(key: "app_theme", defaultValue: Theme.classic.rawValue)
    private static var appTheme: Int

    func save() {
        DispatchQueue(label: "com.chat.theme", qos: .userInteractive).sync {
            Theme.appTheme = self.rawValue
        }
    }

    static var current: Theme {
        return Theme(rawValue: appTheme) ?? .classic
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

// MARK: - Property Wrapper

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
