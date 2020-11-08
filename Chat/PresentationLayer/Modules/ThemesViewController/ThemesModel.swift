//
//  ThemesModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ThemesModelProtocol: class {
    func applyTheme(for: Theme, completion: () -> Void)
}

class ThemesModel: ThemesModelProtocol {
    var themeService: ThemesServiceProtocol
    
    init(themeService: ThemesServiceProtocol) {
        self.themeService = themeService
    }
    
    func applyTheme(for theme: Theme, completion: () -> Void) {
        themeService.applyTheme(for: theme, completion: completion)
    }
}
