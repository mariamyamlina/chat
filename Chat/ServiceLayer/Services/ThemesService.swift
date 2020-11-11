//
//  ThemePicker.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ThemesServiceProtocol {
    func applyTheme(for theme: Theme, completion: () -> Void)
}

class ThemesService {
    let themeStorage: ThemeStorageProtocol

    // MARK: - Init / deinit
    init(themeStorage: ThemeStorageProtocol) {
        self.themeStorage = themeStorage
    }
}

// MARK: - ThemesServiceProtocol
extension ThemesService: ThemesServiceProtocol {
    func applyTheme(for theme: Theme, completion: () -> Void) {
        themeStorage.save(themeRawValue: theme.rawValue, completion: completion)
    }
}
