//
//  ConversationViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 26.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: LogViewController {
    
    var messages: [Message] = []
    var docId: String?

    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageInputContainer: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet weak var borderLine: UIView!
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = textField.text else { return }
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            createMessage(text)
        }
        textField.text = ""
    }
    
    var image: UIImageView?
    var name: String?
    
    private var lastRowIndex: Int = 0
    
    typealias MessageModel = [(MessageTableViewCell.MessageCellModel, UIColor, Date)]
    var model: MessageModel = []
    
    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        
        configureNavigationBar()
        configureTableView()
        
        configureMessageInputView()
        addKeyboardNotifications()

        let queue = DispatchQueue(label: "com.chat.Messages", qos: .userInitiated)
        queue.async {
            self.getMessages()
        }
        
//        reference.document(docId ?? "").collection("messages").addSnapshotListener() { [weak self] snapshot, error in
//            print("")
//        }
    }
    
    // MARK: - Firebase

    private func getMessages() {
        guard let id = docId else { return }
        reference.document(id).collection("messages").getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            var message = ""
            var time = Date()
            var senderId = ""
            var senderName = ""
                
            for document in querySnapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
                let docData = document.data()
                guard let contentFromFB = docData["content"] as? String,
                    let dateFromFB = (docData["created"] as? Timestamp)?.dateValue(),
                    let senderIdFromFB = docData["senderId"] as? String,
                    let senderNameFromFB = docData["senderName"] as? String else { continue }
                message = contentFromFB
                time = dateFromFB
                senderId = senderIdFromFB
                senderName = senderNameFromFB

                self.messages.append(Message(
                    content: message,
                    created: time,
                    senderId: senderId,
                    senderName: senderName))
            }
            self.sortMessages()
            DispatchQueue.main.async {
                if !self.messages.isEmpty {
                    self.noMessagesLabel.isHidden = true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func sortMessages() {
        messages.sort {
            if $1.created > $0.created {
                return true
            } else {
                return false
            }
        }
    }
    
    private func createMessage(_ text: String) {
        let uuid = getUniversallyUniqueIdentifier()
        guard let id = docId else { return }
        let name = ProfileViewController.name ?? "Marina Dudarenko"
        let message = ["content": text, "created": Timestamp(date: Date()), "senderId": getUniversallyUniqueIdentifier(), "senderName": name] as [String: Any]
        messages.append(Message(content: text,
                                created: Date(),
                                senderId: uuid,
                                senderName: name))
        reference.document(id).collection("messages").addDocument(data: message)
        if lastRowIndex >= 0 {
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: lastRowIndex, section: 0)], with: .right)
            tableView.endUpdates()
        } else {
            tableView.reloadSections([0], with: .fade)
        }
    }
    
    // MARK: - Theme
    
    fileprivate func applyTheme() {
        if #available(iOS 13.0, *) {
        } else {
            let currentTheme = Theme.current.themeOptions
            view.backgroundColor = currentTheme.backgroundColor
            textField.keyboardAppearance = currentTheme.keyboardAppearance
        }
    }
    
    // MARK: - MessageInputView
    
    private func configureMessageInputView() {
        let currentTheme = Theme.current.themeOptions
        
        textField.delegate = self
        textField.autocapitalizationType = .sentences
        
        textField.backgroundColor = currentTheme.textFieldBackgroundColor
        textField.attributedPlaceholder = NSAttributedString(string: "Your message here...",
        attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any, NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])

        sendButton.isEnabled = false
        sendButton.isHidden = true
        
        messageInputContainer.backgroundColor = currentTheme.barColor
        borderLine.backgroundColor = Colors.separatorColor()

        topConstraint.isActive = false
        topConstraint = messageInputContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        topConstraint?.isActive = true

        bottomConstraint.isActive = false
        bottomConstraint = messageInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
    }
    
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
                    if self.lastRowIndex >= 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: self.lastRowIndex, section: 0), at: .bottom, animated: true)
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
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        
        noMessagesLabel.textColor = Colors.separatorColor()
        
        tableView?.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = messages.count
        lastRowIndex = numberOfRows - 1
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as? MessageTableViewCell
        let message = messages[indexPath.row]
        let messageCellFactory = ViewModelFactory()
        let messageModel = messageCellFactory.messageToCell(message)
        let currentTheme = Theme.current.themeOptions
        if message.senderId == getUniversallyUniqueIdentifier() {
            cell?.textBubbleView.backgroundColor = currentTheme.outputBubbleColor
        } else {
            cell?.textBubbleView.backgroundColor = currentTheme.inputBubbleColor
        }
        cell?.configure(with: messageModel)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        let stringMessage = "\(message.senderName)\n\(message.content)"

        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 16.0) as Any]
        var estimatedFrame = NSString(string: stringMessage + "    ").boundingRect(with: size, options: options, attributes: attr, context: nil)
        if estimatedFrame.width > UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8 {
            let newWidth: CGFloat = UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8
            estimatedFrame.size.height = estimatedFrame.height * estimatedFrame.width / newWidth
            estimatedFrame.size.width = newWidth
        }
        let rect = CGSize(width: view.frame.width, height: estimatedFrame.height + 42)
        return rect.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 8))
        view.backgroundColor = .clear
        return view
    }
}

// MARK: - UITextFieldDelegate

extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sendButton.isHidden = false
        sendButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sendButton.isHidden = true
        sendButton.isEnabled = false
    }
    
}
