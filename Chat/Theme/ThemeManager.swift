//
//  ThemePicker.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemeManager {
    weak var themesViewController: ThemesViewController?

    init(themesVC: ThemesViewController?) {
        themesViewController = themesVC
        themesViewController?.changeThemeHandler = { [weak self] (_ theme: Theme) -> Void in
            self?.applyTheme(for: theme)
        }
        themesViewController?.delegate = self
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

        themesViewController?.view.backgroundColor = currentTheme.settingsBackgroundColor

        if #available(iOS 13.0, *) {
        } else {
            themesViewController?.navigationController?.navigationBar.barStyle = currentTheme.barStyle
            themesViewController?.navigationController?.navigationBar.barTintColor = currentTheme.barColor
            themesViewController?.titleLabel.textColor = currentTheme.textColor

            let conversationsListVC = themesViewController?.navigationController?.viewControllers.first as? ConversationsListViewController
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
    func changeTheme(for theme: Theme) {
//        applyTheme(for: theme)
    }
}
