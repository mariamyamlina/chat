//
//  ThemePicker.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol IThemesService {
    func applyTheme(for theme: Theme, completion: (Int) -> Void)
}

class ThemesService {
    let themeStorage: IThemeStorage

    // MARK: - Init / deinit
    init(themeStorage: IThemeStorage) {
        self.themeStorage = themeStorage
    }
}

// MARK: - IThemesService
extension ThemesService: IThemesService {
    func applyTheme(for theme: Theme, completion: (Int) -> Void) {
        themeStorage.save(themeRawValue: theme.rawValue, completion: completion)
    }
}
