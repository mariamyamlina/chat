//
//  ThemeStorage.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol IThemeStorage {
    func save(themeRawValue: Int, completion: (Int) -> Void)
    func load() -> Int
}

class ThemeStorage: IThemeStorage {
    func save(themeRawValue: Int, completion: (Int) -> Void) {
        DispatchQueue(label: "com.chat.theme", qos: .userInteractive).sync {
            UserDefaults.standard.set(themeRawValue, forKey: "app_theme")
        }
        completion(themeRawValue)
    }
    
    func load() -> Int {
        return UserDefaults.standard.object(forKey: "app_theme") as? Int ?? Theme.classic.rawValue
    }
}
