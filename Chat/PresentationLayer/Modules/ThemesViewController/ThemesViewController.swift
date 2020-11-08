//
//  ThemesViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemesViewController: LogViewController {
    // MARK: - UI
    var themesView = ThemesView()
    var currentTheme = Theme.current.themeOptions
    
    // MARK: - Dependencies
    private let presentationAssembly: PresentationAssemblyProtocol
    private let model: ThemesModelProtocol
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: ThemesModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createHandlers()
    }
    
    // MARK: - Theme Picker
    
    private func createHandlers() {
        themesView.classicButton.pickHandler = { [weak self, weak themesView] in
            guard let self = self else { return }
            themesView?.pickButtonTapped(themesView?.classicButton ?? ThemeButton())
            self.model.applyTheme(for: .classic, completion: self.applyTheme)
        }
        
        themesView.dayButton.pickHandler = { [weak self, weak themesView] in
            guard let self = self else { return }
            themesView?.pickButtonTapped(themesView?.dayButton ?? ThemeButton())
            self.model.applyTheme(for: .day, completion: self.applyTheme)
        }
        
        themesView.nightButton.pickHandler = { [weak self, weak themesView] in
            guard let self = self else { return }
            themesView?.pickButtonTapped(themesView?.nightButton ?? ThemeButton())
            self.model.applyTheme(for: .night, completion: self.applyTheme)
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
//        model.createThemeService() = ThemesService(themesVC: self)
        applyTheme()
    }
    
    // MARK: - NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = themesView.titleLabel
    }
}
