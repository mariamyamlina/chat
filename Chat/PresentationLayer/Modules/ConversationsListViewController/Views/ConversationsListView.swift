//
//  ConversationsListView.swift
//  Chat
//
//  Created by Maria Myamlina on 06.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationsListView: UIView {
    var profileMenuHandler: (() -> Void)?
    var settingsButtonHandler: (() -> Void)?
    var alertWithTextFieldHandler: (() -> Void)?
    @objc func profileMenuTapped() { profileMenuHandler?() }
    @objc func settingsButtonTapped() { settingsButtonHandler?() }
    @objc func addChannelButtonTapped() { alertWithTextFieldHandler?() }
    
    var currentTheme = Theme.current.themeOptions
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
                NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any,
                NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        } else {
            searchController.searchBar.placeholder = "Search"
        }
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
       return searchController
    }()
    
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
    
    lazy var backBarButtonItem: UIBarButtonItem = { return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) }()
    
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
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        return tableView
    }()
    
    lazy var profileImage: ProfileImageView = {
        let profileImage = ProfileImageView(small: true)
        profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRect(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size))
        applyTheme()
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
    
    func applyTheme() {
        currentTheme = Theme.current.themeOptions
        backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.tableViewSeparatorColor
        tableView.reloadData()
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = currentTheme.searchBarTextColor
            searchController.searchBar.searchTextField.leftView?.tintColor = currentTheme.textFieldTextColor
        } else {
            searchController.searchBar.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
    
    func showNewMessageButton(_ show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.newMessageButton.alpha = show ? 1.0 : 0.0
        }
    }
    
    func setupTextField(_ textField: UITextField?) {
        textField?.autocapitalizationType = .sentences
        textField?.attributedPlaceholder = NSAttributedString(string: "Channel name here",
                                                              attributes: [NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        if #available(iOS 13.0, *) { } else {
            textField?.backgroundColor = currentTheme.textFieldBackgroundColor
            textField?.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
}
