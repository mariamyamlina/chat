//
//  ThemesModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ThemesModelProtocol: class {
    // TODO: - Разобраться с делегатом
    var delegate: ThemesModelDelegate? { get set }
//    var changeThemeHandler: ((_ theme: Theme) -> Void)? { get set }
    func applyTheme(for: Theme, completion: () -> Void)
}

protocol ThemesModelDelegate: class {
    func changeTheme(for theme: Theme)
}

class ThemesModel: ThemesModelProtocol {
    weak var delegate: ThemesModelDelegate?
//    var changeThemeHandler: ((_ theme: Theme) -> Void)?
//    weak var delegate: ThemesPickerDelegate?
    var themeService: ThemesServiceProtocol
    
    init(themeService: ThemesServiceProtocol) {
        self.themeService = themeService
    }
    
    func applyTheme(for theme: Theme, completion: () -> Void) {
        themeService.applyTheme(for: theme, completion: completion)
    }
}
