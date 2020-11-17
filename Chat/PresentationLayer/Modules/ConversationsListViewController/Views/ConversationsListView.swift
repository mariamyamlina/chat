//
//  ConversationsListView.swift
//  Chat
//
//  Created by Maria Myamlina on 06.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationsListView: UIView {
    // MARK: - UI
    var theme: Theme
    var name: String?
    var image: UIImage?
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
                NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any,
                NSAttributedString.Key.foregroundColor: theme.settings.textFieldTextColor])
        } else {
            searchController.searchBar.placeholder = "Search"
        }
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
       return searchController
    }()
    
    lazy var backBarButtonItem: UIBarButtonItem = { return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) }()
    lazy var rightBarButtonItem: UIBarButtonItem = { return configureRightBarButtonItem() }()
    
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SettingsIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Colors.settingsIconColor
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        let barbuttonItem = UIBarButtonItem(customView: button)
        barbuttonItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        barbuttonItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return barbuttonItem
    }()
    
    lazy var newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
        button.setImage(UIImage(named: "NewMessageIcon"), for: .normal)
        button.addTarget(self, action: #selector(addChannelButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 88
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.reuseIdentifier)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return tableView
    }()
    
    lazy var profileImage: ProfileImageView = {
        let profileImage = ProfileImageView(small: true, name: name, image: image)
        profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    // MARK: - Handlers
    var profileMenuHandler: (() -> Void)?
    var settingsButtonHandler: (() -> Void)?
    var alertWithTextFieldHandler: (() -> Void)?
    @objc func profileMenuTapped() { profileMenuHandler?() }
    @objc func settingsButtonTapped() { settingsButtonHandler?() }
    @objc func addChannelButtonTapped() { alertWithTextFieldHandler?() }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme, name: String?, image: UIImage?) {
        self.theme = theme
        self.name = name
        self.image = image
        super.init(frame: CGRect(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size))
        applyTheme(theme: theme)
    }
    
    // MARK: - Setup View
    func applyTheme(theme: Theme) {
        backgroundColor = theme.settings.backgroundColor
        tableView.separatorColor = theme.settings.tableViewSeparatorColor
        tableView.reloadData()
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = theme.settings.searchBarTextColor
            searchController.searchBar.searchTextField.leftView?.tintColor = theme.settings.textFieldTextColor
        } else {
            searchController.searchBar.keyboardAppearance = theme.settings.keyboardAppearance
        }
    }
    
    func configureRightBarButtonItem() -> UIBarButtonItem {
        let rightButton = ButtonWithTouchSize()
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.layer.cornerRadius = rightButton.bounds.width / 2
        rightButton.clipsToBounds = true
        rightButton.addTarget(self, action: #selector(profileMenuTapped), for: .touchUpInside)
        profileImage.addSubview(rightButton)
        return UIBarButtonItem(customView: profileImage)
    }
    
    func showNewMessageButton(_ show: Bool) {
        UIView.animate(withDuration: 0.1) { self.newMessageButton.alpha = show ? 1.0 : 0.0 }
    }
    
    func setupTextField(_ textField: UITextField?) {
        textField?.autocapitalizationType = .sentences
        textField?.attributedPlaceholder = NSAttributedString(string: "Channel name here",
                                                              attributes: [NSAttributedString.Key.foregroundColor: theme.settings.textFieldTextColor])
        if #available(iOS 13.0, *) { } else {
            textField?.backgroundColor = theme.settings.textFieldBackgroundColor
            textField?.keyboardAppearance = theme.settings.keyboardAppearance
        }
    }
    
    func setupNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = true
        navigationBar.addSubview(newMessageButton)
        newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -24).isActive = true
        newMessageButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 58).isActive = true
        newMessageButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        newMessageButton.widthAnchor.constraint(equalTo: newMessageButton.heightAnchor).isActive = true
    }
    
    func setupNavigationItem(navigationItem: UINavigationItem) {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.title = "Channels"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
