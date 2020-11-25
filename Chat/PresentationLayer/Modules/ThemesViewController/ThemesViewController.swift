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
    lazy var themesView = ThemesView(theme: model.currentTheme)
    
    // MARK: - Dependencies
    private let presentationAssembly: IPresentationAssembly
    private let model: IThemesModel
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: IThemesModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(model: presentationAssembly.logModel())
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createHandlers()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(themesView)
        themesView.translatesAutoresizingMaskIntoConstraints = false
        themesView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        themesView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        themesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        themesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        setupNavigationBar()
        applyTheme(themeRawValue: model.currentTheme.rawValue)
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = themesView.titleLabel
    }
    
    func applyTheme(themeRawValue: Int) {
        navigationController?.applyTheme(theme: Theme(rawValue: themeRawValue) ?? .classic)
        themesView.applyTheme(theme: Theme(rawValue: themeRawValue) ?? .classic)
    }
    
    // MARK: - Handlers
    private func createHandlers() {
        themesView.classicButton.pickHandler = { [weak self, weak themesView] in
            guard let self = self, let view = themesView else { return }
            view.pickButtonTapped(view.classicButton)
            self.model.applyTheme(for: .classic, completion: self.applyTheme)
        }
        
        themesView.dayButton.pickHandler = { [weak self, weak themesView] in
            guard let self = self, let view = themesView else { return }
            view.pickButtonTapped(view.dayButton)
            self.model.applyTheme(for: .day, completion: self.applyTheme)
        }
        
        themesView.nightButton.pickHandler = { [weak self, weak themesView] in
            guard let self = self, let view = themesView else { return }
            view.pickButtonTapped(view.nightButton)
            self.model.applyTheme(for: .night, completion: self.applyTheme)
        }
    }
}
