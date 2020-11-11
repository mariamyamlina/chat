//
//  ConversationViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 26.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: LogViewController {
    // MARK: - UI
    private var conversationView = ConversationView()
    
    // MARK: - Dependencies
    private let presentationAssembly: PresentationAssemblyProtocol
    private let model: ConversationModelProtocol

    // MARK: - DisplayModel
    private var dataSource: [MessageCellModel] = []
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: ConversationModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(model: presentationAssembly.logModel())
    }
    
    deinit {
        removeKeyboardNotifications()
        model.removeListener()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupFetchedResultsController()
        createRelationships()
        addKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        conversationView.messageInputContainer.textField.becomeFirstResponder()
    }
    
    // MARK: - Setup View
    func setupView() {
        view.addSubview(conversationView)
        conversationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conversationView.topAnchor.constraint(equalTo: view.topAnchor),
            conversationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            conversationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conversationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        navigationItem.titleView = conversationView.configureTopView(text: model.channel?.name,
                                                                     image: model.channel?.profileImage)
    }
    
    private func setupTableView() {
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
    }
    
    private func setupFetchedResultsController() {
        model.fetchMessages()?.delegate = self
        do {
            try model.fetchMessages()?.performFetch()
        } catch {
            configureLogAlert(withTitle: "Fetch", withMessage: error.localizedDescription)
        }
    }
    
    private func createRelationships() {
        conversationView.messageInputContainer.textField.delegate = self
        conversationView.messageInputContainer.sendHandler = { [weak self, weak conversationView] in
            guard let message = conversationView?.messageInputContainer.textField.text else { return }
            if let unwrChannel = self?.model.channel,
                !message.containtsOnlyOfWhitespaces() {
                self?.model.createMessage(withText: message, inChannel: unwrChannel)
            }
            conversationView?.messageInputContainer.textField.text = ""
        }
        
        if let unwrChannel = model.channel {
            model.getMessages(inChannel: unwrChannel,
                                  errorHandler: { [weak self] (errorTitle, errorInfo) in
                                    self?.configureLogAlert(withTitle: errorTitle, withMessage: errorInfo)
                                    })
        }
    }
    
    // MARK: - Keyboard
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyBoardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            conversationView.messageInputContainerBottomConstraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height ?? 0) : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                if isKeyboardShowing {
                    if let indexPath = self.countIndexPathForLastRow() {
                        self.conversationView.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
                    }
                }
            })
        }
    }
    
    // MARK: - TableView
    private func countIndexPathForLastRow() -> IndexPath? {
        let lastSectionIndex = (model.fetchMessages()?.sections?.count ?? 0) - 1
        var lastRowIndex: Int = -1
        if lastSectionIndex >= 0 {
            lastRowIndex = (model.fetchMessages()?.sections?[lastSectionIndex].numberOfObjects ?? 0) - 1
        }
        if lastSectionIndex >= 0 && lastRowIndex >= 0 {
            return IndexPath(row: lastRowIndex, section: lastSectionIndex)
        } else {
            return nil
        }
    }
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.fetchMessages()?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fetchMessages()?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as? MessageTableViewCell
        
        guard let messageDB = model.fetchMessages()?.object(at: indexPath) else { return UITableViewCell() }
        let message = Message(from: messageDB)
        
        let messageCellFactory = MessageModelFactory()
        let messageModel: MessageCellModel
        if message.senderId == model.universallyUniqueIdentifier() {
            messageModel = messageCellFactory.messageToCell(message, .output)
        } else {
            messageModel = messageCellFactory.messageToCell(message, .input)
        }
        cell?.configure(with: messageModel)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conversationView.messageInputContainer.textField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let messageDB = model.fetchMessages()?.object(at: indexPath) else { return 0 }
        let message = Message(from: messageDB)
        
        let messageCellFactory = MessageModelFactory()
        let messageModel: MessageCellModel
        if message.senderId == model.universallyUniqueIdentifier() {
            messageModel = messageCellFactory.messageToCell(message, .output)
        } else {
            messageModel = messageCellFactory.messageToCell(message, .input)
        }
        return conversationView.calculateHeightForRow(withText: messageModel.text)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfo = model.fetchMessages()?.sections?[section]
        return conversationView.configureViewForHeaderInSection(sectionInfo: sectionInfo?.name ?? "")
    }
}

// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        conversationView.messageInputContainer.textField.resignFirstResponder()
        conversationView.messageInputContainer.sendButtonTapped()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        conversationView.messageInputContainer.enableSendButton(true)
        if let indexPath = self.countIndexPathForLastRow() {
            conversationView.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        conversationView.messageInputContainer.enableSendButton(false)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            conversationView.tableView.insertSections(indexSet, with: .right)
        case .delete:
            conversationView.tableView.deleteSections(indexSet, with: .right)
        case .move, .update:
            conversationView.tableView.reloadSections(indexSet, with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newPath = newIndexPath else { return }
            conversationView.tableView.insertRows(at: [newPath], with: .left)
        case .delete:
            guard let path = indexPath else { return }
            conversationView.tableView.deleteRows(at: [path], with: .left)
        case .move:
            guard let path = indexPath,
                  let newPath = newIndexPath else { return }
            conversationView.tableView.deleteRows(at: [path], with: .left)
            conversationView.tableView.insertRows(at: [newPath], with: .left)
        case .update:
            guard let path = indexPath else { return }
            conversationView.tableView.reloadRows(at: [path], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.endUpdates()
        if let indexPath = self.countIndexPathForLastRow() {
            conversationView.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
        }
    }
}

// MARK: - ConversationModelDelegate
extension ConversationViewController: ConversationModelDelegate {
    func setup(dataSource: [MessageCellModel]) {
        self.dataSource = dataSource
    }
    
    func show(error message: String) {
        
    }
}
