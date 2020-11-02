//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: LogViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 88
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    var isVisible: Bool = false

    var images: [UIImage?] = []
    let fbManager = FirebaseManager.shared
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 13.0, *) {
            let currentTheme = Theme.current.themeOptions
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
        button.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
        button.setImage(UIImage(named: "NewMessageIcon"), for: .normal)
        button.addTarget(self, action: #selector(configureAlertWithTextField), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest = NSFetchRequest<ChannelDB>()
        fetchRequest.entity = ChannelDB.entity()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: "Channels")
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
        fbManager.getChannels()
        guard let height = navigationController?.navigationBar.frame.height else { return }
        showNewMessageButton(height >= 96)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNewMessageButton(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let height = navigationController?.navigationBar.frame.height else { return }
        showNewMessageButton(height >= 96)
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        setupNavigationBar()
        applyTheme()
    }
    
    // MARK: - Theme
    
    func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        view.backgroundColor = currentTheme.backgroundColor
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationController?.navigationBar.barStyle = currentTheme.barStyle
        tableView.separatorColor = currentTheme.tableViewSeparatorColor
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = currentTheme.searchBarTextColor
            searchController.searchBar.searchTextField.leftView?.tintColor = currentTheme.textFieldTextColor
        } else {
            searchController.searchBar.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
    
    fileprivate func applyTheme(for cell: ConversationTableViewCell?) {
        let currentTheme = Theme.current.themeOptions
        cell?.nameLabel.textColor = currentTheme.textColor
        cell?.messageLabel.textColor = currentTheme.messageLabelColor
        cell?.dateLabel.textColor = currentTheme.messageLabelColor
        cell?.onlineIndicator.layer.borderColor = view.backgroundColor?.cgColor
    }
    
    // MARK: - Navigation
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        definesPresentationContext = true
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.title = "Channels"
        
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = true
        
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationBar.standardAppearance
        }
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        button.setImage(UIImage(named: "SettingsIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Colors.settingsIconColor
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        let barbuttonItem = UIBarButtonItem(customView: button)
        barbuttonItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        barbuttonItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navigationItem.leftBarButtonItem = barbuttonItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupRightBarButton()
    
        navigationBar.addSubview(newMessageButton)
        newMessageButton.clipsToBounds = true
        newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newMessageButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -24),
            newMessageButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 58),
            newMessageButton.heightAnchor.constraint(equalToConstant: 24),
            newMessageButton.widthAnchor.constraint(equalTo: newMessageButton.heightAnchor)
        ])
    }
    
    private func showNewMessageButton(_ show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.newMessageButton.alpha = show ? 1.0 : 0.0
        }
    }
    
    func setupRightBarButton() {
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
        let profileController = ProfileViewController()
        let navigationVC = UINavigationController(rootViewController: profileController)
        navigationVC.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        present(navigationVC, animated: true, completion: nil)
    }
    
    @objc private func settingsButtonTapped() {
        let themesController = ThemesViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
        tableView.isHidden = true
        navigationController?.pushViewController(themesController, animated: true)
    }
    
    // MARK: - Alert
    
    @objc private func configureAlertWithTextField() {
        let alertController = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
        alertController.pruneNegativeWidthConstraints()
        alertController.addTextField()
        setupTextField(alertController.textFields?[0])
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak alertController] _ in
            guard let self = self else { return }
            let answer = alertController?.textFields![0].text
            if let channelName = answer,
                !channelName.isEmpty,
                !containtsOnlyOfWhitespaces(string: channelName) {
                self.fbManager.create(channel: channelName)
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
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        if images.isEmpty {
            for _ in 0..<count {
                images.append(generateImage())
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseIdentifier, for: indexPath) as? ConversationTableViewCell
        
        let channelDB = fetchedResultsController.object(at: indexPath)
        let channel = Channel(from: channelDB)
        
        var image: UIImage?
        if images.count > indexPath.row {
            image = images[indexPath.row]
        } else {
            image = nil
        }
        
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

        let conversationController = ConversationViewController()
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell
        
        conversationController.name = cell?.nameLabel.text
        conversationController.image = cell?.configureImageSubview()

        let channelDB = fetchedResultsController.object(at: indexPath)
        let channel = Channel(from: channelDB)
        conversationController.channel = channel

        navigationController?.pushViewController(conversationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channelDB = fetchedResultsController.object(at: indexPath)
            let channel = Channel(from: channelDB)
            fbManager.delete(channel: channel.identifier)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ConversationsListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        showNewMessageButton(height >= 96)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard isVisible else { return }
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        guard isVisible else { return }
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .top)
        case .delete:
            tableView.deleteSections(indexSet, with: .top)
        case .move, .update:
            tableView.reloadSections(indexSet, with: .top)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard isVisible else { return }
        switch type {
        case .insert:
            guard let newPath = newIndexPath else { return }
            if images.count > newPath.row {
                images.insert(generateImage(), at: newPath.row)
            }
            tableView.insertRows(at: [newPath], with: .top)
        case .delete:
            guard let path = indexPath else { return }
            if images.count > path.row {
                images.insert(generateImage(), at: path.row)
            }
            tableView.deleteRows(at: [path], with: .top)
        case .move:
            guard let path = indexPath,
                  let newPath = newIndexPath else { return }
            if images.count > newPath.row, images.count > path.row {
                let image = images[path.row]
                images.remove(at: path.row)
                images.insert(image, at: newPath.row)
            }
            tableView.deleteRows(at: [path], with: .top)
            tableView.insertRows(at: [newPath], with: .top)
        case .update:
            guard let path = indexPath else { return }
            tableView.reloadRows(at: [path], with: .top)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard isVisible else { return }
        tableView.endUpdates()
    }
}
