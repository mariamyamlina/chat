//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationsListViewController: LogViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 13.0, *) {
            let currentTheme = Theme.current.themeOptions
            
            searchController.searchBar.searchTextField.backgroundColor = currentTheme.searchBarTextColor
            searchController.searchBar.searchTextField.leftView?.tintColor = currentTheme.textFieldTextColor
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                                                  attributes: [NSAttributedString.Key.font : UIFont(name: "SFProText-Regular", size: 17) as Any, NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        } else {
            searchController.searchBar.placeholder = "Search"
        }
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
       return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyTheme()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = false
    }
    
    
    // MARK: - Theme
    
    fileprivate func applyTheme() {
        if #available(iOS 13.0, *) {
        } else {
            let currentTheme = Theme.current.themeOptions
            
            view.backgroundColor = currentTheme.backgroundColor

            tableView.separatorColor = currentTheme.tableViewSeparatorColor
            
            navigationController?.navigationBar.barTintColor = currentTheme.barColor
            navigationController?.navigationBar.barStyle = currentTheme.barStyle
            
            searchController.searchBar.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
    
    fileprivate func applyTheme(for cell: ConversationTableViewCell?) {
        cell?.profileImage.layer.cornerRadius = (cell?.profileImage.bounds.size.width ?? 48) / 2
        cell?.onlineIndicator.layer.cornerRadius = (cell?.onlineIndicator.bounds.width ?? 18) / 2
        if #available(iOS 13.0, *) {
        } else {
            let currentTheme = Theme.current.themeOptions
            
            cell?.nameLabel.textColor = currentTheme.inputAndCommonTextColor
            cell?.messageLabel.textColor = currentTheme.textFieldTextColor
            cell?.dateLabel.textColor = currentTheme.textFieldTextColor
        }
    }
    
    
    // MARK: - Navigation
    
    private func setupNavigationBar() {
        definesPresentationContext = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = true
        
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Colors.settingsIconColor
        
        updateProfileImageView()
    }
    
    func updateProfileImageView() {
        let profileImage = ProfileImageView(small: true)
        profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentView.backgroundColor = navigationController?.navigationBar.backgroundColor

        let rightButton = ButtonWithTouchSize()
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.layer.cornerRadius = rightButton.bounds.width / 2
        rightButton.clipsToBounds = true
        rightButton.addTarget(self, action: #selector(profileMenuTapped), for: .touchUpInside)
        profileImage.addSubview(rightButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImage)
    }
    
    @objc private func profileMenuTapped() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = storyboard.instantiateViewController(withIdentifier: "Profile VC")
        let navigationVC = UINavigationController(rootViewController: profileController)
        navigationVC.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        present(navigationVC, animated: true, completion: nil)
    }
    
    @objc private func settingsButtonTapped() {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        let themesController = storyboard.instantiateViewController(withIdentifier: "Themes VC")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
        tableView.isHidden = true
        navigationController?.pushViewController(themesController, animated: true)
    }
    
    
    // MARK: - TableView
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 88
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.sectionFooterHeight = 0

        tableView?.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: ConversationTableViewCell.reuseIdentifier)
    }

}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionOnlineCount = 0
        var sectionOfflineCount = 0
        
        for friend in ConversationModel.friends {
            if friend.isOnline {
                sectionOnlineCount += 1
            } else if !friend.isOnline && !friend.message.isEmpty {
                sectionOfflineCount += 1
            }
        }
        
        switch section {
        case 0:
            return sectionOnlineCount
        case 1:
            return sectionOfflineCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseIdentifier, for: indexPath) as? ConversationTableViewCell
        
        cell?.configure(with: ConversationModel.friends[indexPath.row + indexPath.section * self.tableView(tableView, numberOfRowsInSection: 0)])
        applyTheme(for: cell)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = storyboard.instantiateViewController(withIdentifier: "Conversation VC") as? ConversationViewController
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell
        
        conversationController?.name = cell?.nameLabel.text
        conversationController?.image = cell?.configureImageSubview()
        if cell?.messageLabel.text != "No messages yet" {
            conversationController?.lastMessage = cell?.messageLabel.text
        }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(conversationController ?? UIViewController(), animated: true)
    }
}
