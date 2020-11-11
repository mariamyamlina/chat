//
//  Settings.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class Settings {
    private static let rootAssembly = RootAssembly()
    
    static var currentTheme: Theme {
        return Theme(rawValue: rootAssembly.themeStorage.get()) ?? .classic
    }
    
    static var name: String?
    static var bio: String?
    static var image: UIImage?
}
