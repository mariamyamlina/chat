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

    static var channels: [Channel] = []
    static var images: [UIImage?] = []
    let fbManager = FirebaseManager.shared
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 13.0, *) {
            let currentTheme = Theme.current.themeOptions
            searchController.searchBar.searchTextField.backgroundColor = currentTheme.searchBarTextColor
            searchController.searchBar.searchTextField.leftView?.tintColor = currentTheme.textFieldTextColor
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
                NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any,
                NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        } else {
            searchController.searchBar.placeholder = "Search"
        }
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
       return searchController
    }()
    
    lazy var newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "NewMessageIcon"), for: .normal)
        button.addTarget(self, action: #selector(addNewMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        setupNavigationBar()
        setupTableView()

        fbManager.getChannels(completion: getChannelsCompletion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let height = navigationController?.navigationBar.frame.height else { return }
        showNewMessageButton(height >= 96)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNewMessageButton(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let height = navigationController?.navigationBar.frame.height else { return }
        showNewMessageButton(height >= 96)
    }
    
    // MARK: - Firebase
    
    func getChannelsCompletion() {
        let chatRequest = CoreDataManager(coreDataStack: CoreDataStack.shared)
        chatRequest.makeRequest(channels: ConversationsListViewController.channels)
        
        sortChannels()
        tableView.reloadData()
    }
    
    func sortChannels() {
        ConversationsListViewController.channels.sort {
            let date = Date(timeInterval: -50000000000, since: Date())
            let firstDate = $0.lastActivity ?? date
            let secondDate = $1.lastActivity ?? date
            if secondDate < firstDate {
                return true
            } else if $0.lastMessage != nil && $1.lastMessage == nil {
                return true
            } else {
                return false
            }
        }
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
            cell?.nameLabel.textColor = currentTheme.textColor
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
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(newMessageButton)
        newMessageButton.clipsToBounds = true
        newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newMessageButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -21),
            newMessageButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 55),
            newMessageButton.heightAnchor.constraint(equalToConstant: 30),
            newMessageButton.widthAnchor.constraint(equalTo: newMessageButton.heightAnchor)
            ])
    }
    
    private func showNewMessageButton(_ show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.newMessageButton.alpha = show ? 1.0 : 0.0
        }
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
    
    @objc func addNewMessageButtonTapped() {
        configureAlertWithTextField()
    }
    
    // MARK: - Alert
    
    private func configureAlertWithTextField() {
        let alertController = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
        alertController.pruneNegativeWidthConstraints()
        alertController.addTextField()
        setupTextField(alertController.textFields?[0])
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak alertController] _ in
            guard let self = self else { return }
            let answer = alertController?.textFields![0].text
            if let channelName = answer, !channelName.isEmpty, !channelName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.fbManager.createChannel(channelName, completion: self.getChannelsCompletion)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [createAction, cancelAction].forEach { alertController.addAction($0) }
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupTextField(_ textField: UITextField?) {
        let currentTheme = Theme.current.themeOptions
        textField?.autocapitalizationType = .sentences
        textField?.attributedPlaceholder = NSAttributedString(string: "Channel name here",
                                                              attributes: [NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        if #available(iOS 13.0, *) { } else {
            textField?.backgroundColor = currentTheme.textFieldBackgroundColor
            textField?.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
    
    // MARK: - TableView
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 88
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false

        tableView?.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: ConversationTableViewCell.reuseIdentifier)
    }

}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationsListViewController.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseIdentifier, for: indexPath) as? ConversationTableViewCell
        
        let channel = ConversationsListViewController.channels[indexPath.row]
        let image = ConversationsListViewController.images[indexPath.row]
        let channelCellFactory = ViewModelFactory()
        let channelModel = channelCellFactory.channelToCell(channel, image)
        cell?.configure(with: channelModel)
        applyTheme(for: cell)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = storyboard.instantiateViewController(withIdentifier: "Conversation VC") as? ConversationViewController
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell
        
        conversationController?.name = cell?.nameLabel.text
        conversationController?.image = cell?.configureImageSubview()

        let channel = ConversationsListViewController.channels[indexPath.row]
        ConversationViewController.channel = channel

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(conversationController ?? UIViewController(), animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ConversationsListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        showNewMessageButton(height >= 96)
    }
}
