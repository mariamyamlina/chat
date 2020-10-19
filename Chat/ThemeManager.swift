//
//  ThemePicker.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemeManager {

    static var themesViewController: ThemesViewController?

    init() {
        
//        CLOSURE
        ThemeManager.themesViewController?.changeThemeHandler = { [weak self] (_ theme: Theme) -> Void in
            self?.applyTheme(for: theme)
        }
        ThemeManager.themesViewController?.delegate = self
    }
    
    func applyTheme(for theme: Theme) {
        switch theme {
        case .classic:
            guard let theme = Theme(rawValue: 0) else { return }
            theme.setActive()
        case .day:
            guard let theme = Theme(rawValue: 1) else { return }
            theme.setActive()
        case .night:
            guard let theme = Theme(rawValue: 2) else { return }
            theme.setActive()
        }
        
        let currentTheme = Theme.current.themeOptions

        let themesVC = ThemeManager.themesViewController
        themesVC?.view.backgroundColor = currentTheme.settingsBackgroundColor

        if #available(iOS 13.0, *) {
        } else {
            themesVC?.navigationController?.navigationBar.barStyle = currentTheme.barStyle
            themesVC?.navigationController?.navigationBar.barTintColor = currentTheme.barColor
            themesVC?.titleLabel.textColor = currentTheme.inputAndCommonTextColor

            let conversationsListVC = themesVC?.navigationController?.viewControllers.first as? ConversationsListViewController
            conversationsListVC?.view.backgroundColor = currentTheme.backgroundColor

            conversationsListVC?.tableView.reloadData()
            conversationsListVC?.tableView.separatorColor = currentTheme.tableViewSeparatorColor

            conversationsListVC?.navigationController?.navigationBar.barTintColor = currentTheme.barColor
            conversationsListVC?.navigationController?.navigationBar.barStyle = currentTheme.barStyle

            conversationsListVC?.searchController.searchBar.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
}


// MARK: - ThemesPickerDelegate

extension ThemeManager: ThemesPickerDelegate {
    
//    DELEGATE METHOD
    func changeTheme(for theme: Theme) {
//        applyTheme(for: theme)
    }
}

