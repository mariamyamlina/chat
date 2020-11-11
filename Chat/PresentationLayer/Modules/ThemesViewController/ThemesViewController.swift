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
    private let presentationAssembly: PresentationAssemblyProtocol
    private let model: ThemesModelProtocol
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: ThemesModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
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
    
    func applyTheme(themeRawValue: Int) {
        navigationController?.applyTheme(theme: Theme(rawValue: themeRawValue) ?? .classic)
        themesView.applyTheme(theme: Theme(rawValue: themeRawValue) ?? .classic)
    }
    
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
        applyTheme(themeRawValue: model.currentTheme.rawValue)
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = themesView.titleLabel
    }
}
