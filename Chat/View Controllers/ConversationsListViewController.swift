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
    private var isVisible: Bool = false
    private var images: [UIImage?] = []
    var currentTheme = Theme.current.themeOptions
    private let fbManager = FirebaseManager.shared
    var conversationsListView = ConversationsListView()
    
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
            configureLogAlert(withTitle: "Fetch", withMessage: error.localizedDescription)
        }
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createRelationships()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationsListView.tableView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
        fbManager.getChannels(errorHandler: { [weak self] (errorTitle, errorInfo) in
            self?.configureLogAlert(withTitle: errorTitle, withMessage: errorInfo)
        })
        guard let height = navigationController?.navigationBar.frame.height else { return }
        conversationsListView.showNewMessageButton(height >= 96)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isVisible = false
        fbManager.removeChannelsListener()
        conversationsListView.showNewMessageButton(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let height = navigationController?.navigationBar.frame.height else { return }
        conversationsListView.showNewMessageButton(height >= 96)
    }
    
    private func setupView() {
        view.addSubview(conversationsListView)
        conversationsListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conversationsListView.topAnchor.constraint(equalTo: view.topAnchor),
            conversationsListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            conversationsListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conversationsListView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        setupNavigationBar()
        applyTheme()
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.prefersLargeTitles = true
        navigationItem.searchController = conversationsListView.searchController
        navigationItem.title = "Channels"
        
        navigationItem.hidesSearchBarWhenScrolling = true
        
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationBar.standardAppearance
        }
        
        navigationItem.rightBarButtonItem = conversationsListView.rightBarButtonItem
        navigationItem.leftBarButtonItem = conversationsListView.leftBarButtonItem
        navigationItem.backBarButtonItem = conversationsListView.backBarButtonItem
        
        navigationBar.addSubview(conversationsListView.newMessageButton)
        conversationsListView.newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conversationsListView.newMessageButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -24),
            conversationsListView.newMessageButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 58),
            conversationsListView.newMessageButton.heightAnchor.constraint(equalToConstant: 24),
            conversationsListView.newMessageButton.widthAnchor.constraint(equalTo: conversationsListView.newMessageButton.heightAnchor)
        ])
    }
    
    private func createRelationships() {
        conversationsListView.tableView.delegate = self
        conversationsListView.tableView.dataSource = self
        
        conversationsListView.profileMenuHandler = { [weak self] in
            let profileController = ProfileViewController()
            let navigationVC = UINavigationController(rootViewController: profileController)
            navigationVC.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            self?.present(navigationVC, animated: true, completion: nil)
        }
        
        conversationsListView.settingsButtonHandler = { [weak self] in
            let themesController = ThemesViewController()
            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
            self?.conversationsListView.tableView.isHidden = true
            self?.navigationController?.pushViewController(themesController, animated: true)
        }
        
        conversationsListView.alertWithTextFieldHandler = { [weak self, weak conversationsListView] in
            let alertController = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            conversationsListView?.setupTextField(alertController.textFields?[0])
            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak alertController] _ in
                guard let self = self else { return }
                if let channelName = alertController?.textFields![0].text,
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
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Theme
    
    func applyTheme() {
        currentTheme = Theme.current.themeOptions
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationController?.navigationBar.barStyle = currentTheme.barStyle
        conversationsListView.applyTheme()
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
        }
        
        let channelCellFactory = ViewModelFactory()
        let channelModel = channelCellFactory.channelToCell(channel, image)
        cell?.configure(with: channelModel)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let channelDB = fetchedResultsController.object(at: indexPath)
        let channel = Channel(from: channelDB)
        
        let conversationController = ConversationViewController(channel: channel, image: UIImageView(image: images[indexPath.row]))

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
        conversationsListView.showNewMessageButton(height >= 96)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard isVisible else { return }
        conversationsListView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        guard isVisible else { return }
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            conversationsListView.tableView.insertSections(indexSet, with: .right)
        case .delete:
            conversationsListView.tableView.deleteSections(indexSet, with: .right)
        case .move, .update:
            conversationsListView.tableView.reloadSections(indexSet, with: .fade)
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
            conversationsListView.tableView.insertRows(at: [newPath], with: .right)
        case .delete:
            guard let path = indexPath else { return }
            if images.count > path.row {
                images.insert(generateImage(), at: path.row)
            }
            conversationsListView.tableView.deleteRows(at: [path], with: .right)
        case .move:
            guard let path = indexPath,
                  let newPath = newIndexPath else { return }
            if images.count > newPath.row, images.count > path.row {
                let image = images[path.row]
                images.remove(at: path.row)
                images.insert(image, at: newPath.row)
            }
            conversationsListView.tableView.deleteRows(at: [path], with: .right)
            conversationsListView.tableView.insertRows(at: [newPath], with: .right)
        case .update:
            guard let path = indexPath else { return }
            conversationsListView.tableView.reloadRows(at: [path], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard isVisible else { return }
        conversationsListView.tableView.endUpdates()
    }
}
