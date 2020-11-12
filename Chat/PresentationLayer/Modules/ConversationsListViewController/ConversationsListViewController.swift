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
    // MARK: - UI
    lazy var conversationsListView = ConversationsListView(theme: model.currentTheme, name: model.name, image: model.image)
    
    // MARK: - Dependencies
    private let presentationAssembly: IPresentationAssembly
    private let model: IConversationsListModel
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: IConversationsListModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(model: presentationAssembly.logModel())
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupFetchedResultsController()
        createHandlers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationsListView.tableView.isHidden = false
        applyTheme(theme: model.currentTheme)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.getChannels(errorHandler: { [weak self] (errorTitle, errorInfo) in
            self?.configureLogAlert(withTitle: errorTitle, withMessage: errorInfo)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.removeListener()
        conversationsListView.showNewMessageButton(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let height = navigationController?.navigationBar.frame.height else { return }
        conversationsListView.showNewMessageButton(height >= 96)
    }
    
    // MARK: - Setup View
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
    }
    
    func applyTheme(theme: Theme) {
        navigationController?.applyTheme(theme: theme)
        conversationsListView.applyTheme(theme: theme)
        guard #available(iOS 13.0, *) else { return }
        UIApplication.shared.windows.forEach { $0.overrideUserInterfaceStyle = model.currentTheme.userInterfaceStyle }
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        conversationsListView.setupNavigationItem(navigationItem: navigationItem)
        conversationsListView.setupNavigationBar(navigationBar: navigationBar)
        updateImageView()
    }
    
    private func setupTableView() {
        conversationsListView.tableView.delegate = self
        conversationsListView.tableView.dataSource = self
    }
    
    // MARK: - FetchedResultsController
    private func setupFetchedResultsController() {
        model.frc.delegate = self
        do {
            try model.frc.performFetch()
        } catch {
            configureLogAlert(withTitle: "Fetch", withMessage: error.localizedDescription)
        }
    }
    
    // MARK: - Handlers
    func loadCompletion() {
        conversationsListView.profileImage.loadImageCompletion(name: model.name, image: model.image)
    }
        
    func updateImageView() {
        model.loadWithGCD(completion: loadCompletion)
//        model.loadWithOperations(completion: loadCompletion)
    }
    
    private func createHandlers() {
        conversationsListView.profileMenuHandler = { [weak self] in
            guard let self = self else { return }
            let profileController = self.presentationAssembly.profileViewController().embedInNavigationController()
            profileController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            self.present(profileController, animated: true, completion: nil)
        }
        
        conversationsListView.settingsButtonHandler = { [weak self] in
            guard let self = self else { return }
            let themesController = self.presentationAssembly.themesViewController()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
            self.conversationsListView.tableView.isHidden = true
            self.navigationController?.pushViewController(themesController, animated: true)
        }
        
        conversationsListView.alertWithTextFieldHandler = { [weak self, weak model, weak conversationsListView] in
            let alertController = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            conversationsListView?.setupTextField(alertController.textFields?[0])
            let createAction = UIAlertAction(title: "Create", style: .default) { [weak model, weak alertController] _ in
                if let channelName = alertController?.textFields![0].text,
                    !channelName.containtsOnlyOfWhitespaces() {
                    model?.createChannel(withName: channelName)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            [createAction, cancelAction].forEach { alertController.addAction($0) }
            alertController.applyTheme(theme: model?.currentTheme ?? .classic)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.frc.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseIdentifier, for: indexPath) as? ConversationTableViewCell
        cell?.configure(with: model.channelModel(at: indexPath), theme: model.currentTheme)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationController = presentationAssembly.conversationViewController(channel: model.channel(at: indexPath))
        navigationController?.pushViewController(conversationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteChannel(at: indexPath)
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
        guard navigationController?.topViewController == self else { return }
        conversationsListView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        guard navigationController?.topViewController == self else { return }
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
        guard navigationController?.topViewController == self else { return }
        switch type {
        case .insert:
            guard let newPath = newIndexPath else { return }
            conversationsListView.tableView.insertRows(at: [newPath], with: .right)
        case .delete:
            guard let path = indexPath else { return }
            conversationsListView.tableView.deleteRows(at: [path], with: .right)
        case .move:
            guard let path = indexPath,
                let newPath = newIndexPath else { return }
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
        guard navigationController?.topViewController == self else { return }
        conversationsListView.tableView.endUpdates()
    }
}
