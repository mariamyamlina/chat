//
//  ThemeStorage.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ThemeStorageProtocol {
    func save(themeRawValue: Int, completion: () -> Void)
    func get() -> Int
}

class ThemeStorage: ThemeStorageProtocol {
    func save(themeRawValue: Int, completion: () -> Void) {
        DispatchQueue(label: "com.chat.theme", qos: .userInteractive).sync {
            UserDefaults.standard.set(themeRawValue, forKey: "app_theme")
        }
        completion()
    }
    
    func get() -> Int {
        return UserDefaults.standard.object(forKey: "app_theme") as? Int ?? Theme.classic.rawValue
    }
}
