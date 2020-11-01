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
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 14))
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        tableView.sectionFooterHeight = 0
        
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    fileprivate lazy var messageInputContainer: MessageInputContainer = { return MessageInputContainer() }()
    
    fileprivate lazy var noMessagesLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No messages yet"
        label.font = UIFont(name: "SFProText-Semibold", size: 16.0)
        label.textAlignment = .center
        return label
    }()
    
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
            print(error.localizedDescription)
        }
        
        return fetchedResultsController
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    var image: UIImageView?
    var name: String?

    var channel: Channel?
    let fbManager = FirebaseManager.shared
    
    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addKeyboardNotifications()
        
        if let unwrChannel = channel {
            fbManager.getMessages(in: unwrChannel, completion: { [weak self] in
                guard let self = self else { return }
                if let indexPath = self.countIndexPathForLastRow() {
                    self.noMessagesLabel.isHidden = true
                    self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
                } else {
                    self.noMessagesLabel.isHidden = false
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputContainer.textField.becomeFirstResponder()
    }
    
    // MARK: - Views
    
    func setupViews() {
        view.addSubview(noMessagesLabel)
        view.addSubview(tableView)
        view.addSubview(messageInputContainer)

        noMessagesLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainer.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noMessagesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            noMessagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            messageInputContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        applyTheme()
        configureNavigationBar()
        
        messageInputContainer.textField.delegate = self
        messageInputContainer.sendHandler = { [weak self] in
            guard let message = self?.messageInputContainer.textField.text else { return }
            if let unwrChannel = self?.channel,
                !containtsOnlyOfWhitespaces(string: message) {
                self?.fbManager.create(message: message, in: unwrChannel)
            }
            self?.messageInputContainer.textField.text = ""
        }
    }
    
    // MARK: - Theme
    
    fileprivate func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        view.backgroundColor = currentTheme.backgroundColor
        noMessagesLabel.textColor = currentTheme.textFieldTextColor
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
            bottomConstraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height ?? 0) : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                if isKeyboardShowing {
                    if let indexPath = self.countIndexPathForLastRow() {
                        self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
                    }
                }
            })
        }
    }
    
    // MARK: - Navigation
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }

        guard let titleImageView = image else { return }
        
        let viewWithTitle = TopViewWithTitle()
        viewWithTitle.frame = CGRect(x: 0, y: 0, width: 236, height: 36)
        viewWithTitle.contentView.backgroundColor = navigationController?.navigationBar.backgroundColor
        viewWithTitle.profileImage.image = titleImageView.image
        viewWithTitle.profileImage.layer.cornerRadius = viewWithTitle.profileImage.bounds.size.width / 2
        viewWithTitle.nameLabel.text = name
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: 236, height: 36))
        topView.layer.cornerRadius = topView.bounds.width / 2
        topView.clipsToBounds = true
        topView.addSubview(viewWithTitle)
        navigationItem.titleView = viewWithTitle
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
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
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
        let currentTheme = Theme.current.themeOptions
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
        messageInputContainer.textField.endEditing(true)
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 28))
        headerView.backgroundColor = .clear

        let sectionInfo = fetchedResultsController.sections?[section]
        let text = sectionInfo?.name ?? ""

        let dateLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 3, y: 4, width: UIScreen.main.bounds.width / 3, height: 20))
        dateLabel.layer.cornerRadius = dateLabel.bounds.height / 2
        dateLabel.clipsToBounds = true
        dateLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        dateLabel.textAlignment = .center
        dateLabel.text = text

        let currentTheme = Theme.current.themeOptions
        dateLabel.textColor = currentTheme.tableViewHeaderTextColor
        dateLabel.backgroundColor = currentTheme.tableViewHeaderColor

        headerView.addSubview(dateLabel)
        return headerView
    }
}

// MARK: - UITextFieldDelegate

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInputContainer.textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        messageInputContainer.sendButton.isHidden = false
        messageInputContainer.sendButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageInputContainer.sendButton.isHidden = true
        messageInputContainer.sendButton.isEnabled = false
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .left)
        case .delete:
            tableView.deleteSections(indexSet, with: .left)
        case .move, .update:
            tableView.reloadSections(indexSet, with: .left)
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
            tableView.insertRows(at: [newPath], with: .left)
        case .delete:
            guard let path = indexPath else { return }
            tableView.deleteRows(at: [path], with: .left)
        case .move:
            guard let path = indexPath,
                  let newPath = newIndexPath else { return }
            tableView.deleteRows(at: [path], with: .left)
            tableView.insertRows(at: [newPath], with: .left)
        case .update:
            guard let path = indexPath else { return }
            tableView.reloadRows(at: [path], with: .left)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()

        if let indexPath = self.countIndexPathForLastRow() {
            self.noMessagesLabel.isHidden = true
            tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .bottom, animated: true)
        } else {
            self.noMessagesLabel.isHidden = false
        }
    }
}
