//
//  ThemesViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemesViewController: LogViewController {
    var changeThemeHandler: ((_ theme: Theme) -> Void)?
    weak var delegate: ThemesPickerDelegate?
    private var themeManager: ThemeService?
    var themesView = ThemesView()
    var currentTheme = Theme.current.themeOptions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createRelationships()
    }
    
    // MARK: - Theme Picker
    
    private func createRelationships() {
        themesView.classicButton.pickHandler = { [weak self, weak themesView] in
            themesView?.pickButtonTapped(themesView?.classicButton ?? ThemeButton())
            self?.changeThemeHandler?(.classic)
            self?.delegate?.changeTheme(for: .classic)
        }
        
        themesView.dayButton.pickHandler = { [weak self, weak themesView] in
            themesView?.pickButtonTapped(themesView?.dayButton ?? ThemeButton())
            self?.changeThemeHandler?(.day)
            self?.delegate?.changeTheme(for: .day)
        }
        
        themesView.nightButton.pickHandler = { [weak self, weak themesView] in
            themesView?.pickButtonTapped(themesView?.nightButton ?? ThemeButton())
            self?.changeThemeHandler?(.night)
            self?.delegate?.changeTheme(for: .night)
        }
    }
    
    func applyTheme() {
        currentTheme = Theme.current.themeOptions
        if #available(iOS 13.0, *) {
        } else {
            navigationController?.navigationBar.barStyle = currentTheme.barStyle
            navigationController?.navigationBar.barTintColor = currentTheme.barColor
        }
        themesView.applyTheme()
    }
    
    // MARK: - View
    
    private func setupView() {
        view.addSubview(themesView)
        themesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themesView.topAnchor.constraint(equalTo: view.topAnchor),
            themesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            themesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themesView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        setupNavigationBar()
        themeManager = ThemeService(themesVC: self)
        applyTheme()
    }
    
    // MARK: - NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = themesView.titleLabel
    }
}
