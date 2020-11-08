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

class ThemesService: ThemesServiceProtocol {
    func applyTheme(for theme: Theme, completion: () -> Void) {
        switch theme {
        case .classic:
            Theme(rawValue: 0)?.setActive()
        case .day:
            Theme(rawValue: 1)?.setActive()
        case .night:
            Theme(rawValue: 2)?.setActive()
        }
        completion()
    }
}
