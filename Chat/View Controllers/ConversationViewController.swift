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
    var image: UIImageView?
    var channel: Channel?
    private let fbManager = FirebaseManager.shared
    private var conversationView = ConversationView(withTitle: nil, withImage: nil)
    let currentTheme = Theme.current.themeOptions
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let channelId = channel?.identifier ?? ""
        let fetchRequest = NSFetchRequest<MessageDB>()
        fetchRequest.entity = MessageDB.entity()
        let predicate = NSPredicate(format: "channel.identifier = %@", channelId)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataStack.shared.mainContext,
                                                                  sectionNameKeyPath: "formattedDate",
                                                                  cacheName: "Messages in channel with id \(channelId)")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            configureLogAlert(withTitle: "Fetch", withMessage: error.localizedDescription)
        }
        return fetchedResultsController
    }()
    
    deinit {
        removeKeyboardNotifications()
        fbManager.removeMessagesListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addKeyboardNotifications()
        
        if let unwrChannel = channel {
            fbManager.getMessages(in: unwrChannel,
                                  errorHandler: { [weak self] (errorTitle, errorInfo) in
                                    self?.configureLogAlert(withTitle: errorTitle, withMessage: errorInfo)
                                    },
                                  completion: { [weak self, weak conversationView] in
                                    guard let self = self else { return }
                                    guard let unwrView = conversationView else { return }
                                    if let indexPath = self.countIndexPathForLastRow() {
                                        unwrView.noMessagesLabel.isHidden = true
                                        unwrView.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
                                    } else {
                                        unwrView.noMessagesLabel.isHidden = false
                                    }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        conversationView.messageInputContainer.textField.becomeFirstResponder()
    }
    
    // MARK: - Views
    
    func setupViews() {
        conversationView = ConversationView(withTitle: channel?.name, withImage: image)
        view.addSubview(conversationView)
        conversationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conversationView.topAnchor.constraint(equalTo: view.topAnchor),
            conversationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            conversationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conversationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        configureNavigationBar()
        
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
        
        conversationView.messageInputContainer.textField.delegate = self
        conversationView.messageInputContainer.sendHandler = { [weak self, weak conversationView] in
            guard let message = conversationView?.messageInputContainer.textField.text else { return }
            if let unwrChannel = self?.channel,
                !containtsOnlyOfWhitespaces(string: message) {
                self?.fbManager.create(message: message, in: unwrChannel)
            }
            conversationView?.messageInputContainer.textField.text = ""
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
            conversationView.bottomConstraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height ?? 0) : 0
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
    
    // MARK: - NavigationBar
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        navigationItem.titleView = conversationView.viewWithTitle
    }
    
    // MARK: - TableView
    
    private func countIndexPathForLastRow() -> IndexPath? {
        let lastSectionIndex = (fetchedResultsController.sections?.count ?? 0) - 1
        var lastRowIndex: Int = -1
        if lastSectionIndex >= 0 {
            lastRowIndex = (fetchedResultsController.sections?[lastSectionIndex].numberOfObjects ?? 0) - 1
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
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as? MessageTableViewCell
        
        let messageDB = fetchedResultsController.object(at: indexPath)
        let message = Message(from: messageDB)
        
        let messageCellFactory = ViewModelFactory()
        let messageModel: MessageTableViewCell.MessageCellModel
        if message.senderId == fbManager.universallyUniqueIdentifier {
            cell?.textBubbleView.backgroundColor = currentTheme.outputBubbleColor
            messageModel = messageCellFactory.messageToCell(message, .output)
        } else {
            cell?.textBubbleView.backgroundColor = currentTheme.inputBubbleColor
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
        let messageDB = fetchedResultsController.object(at: indexPath)
        let message = Message(from: messageDB)
        
        let messageCellFactory = ViewModelFactory()
        let messageModel: MessageTableViewCell.MessageCellModel
        if message.senderId == fbManager.universallyUniqueIdentifier {
            messageModel = messageCellFactory.messageToCell(message, .output)
        } else {
            messageModel = messageCellFactory.messageToCell(message, .input)
        }

        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 16.0) as Any]
        var estimatedFrame = NSString(string: messageModel.text + "\t").boundingRect(with: size, options: options, attributes: attr, context: nil)
        if estimatedFrame.width > UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8 {
            let newWidth: CGFloat = UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8
            estimatedFrame.size.height = estimatedFrame.height * estimatedFrame.width / newWidth
            estimatedFrame.size.width = newWidth
        }
        let rect = CGSize(width: view.frame.width, height: estimatedFrame.height + 42)
        return rect.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfo = fetchedResultsController.sections?[section]
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
        conversationView.messageInputContainer.sendButton.isHidden = false
        conversationView.messageInputContainer.sendButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        conversationView.messageInputContainer.sendButton.isHidden = true
        conversationView.messageInputContainer.sendButton.isEnabled = false
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
            conversationView.noMessagesLabel.isHidden = true
            conversationView.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
        } else {
            conversationView.noMessagesLabel.isHidden = false
        }
    }
}
