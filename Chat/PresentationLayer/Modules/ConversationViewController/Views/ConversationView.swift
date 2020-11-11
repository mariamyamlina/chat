//
//  ConversationView.swift
//  Chat
//
//  Created by Maria Myamlina on 07.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationView: UIView {
    // MARK: - UI
    var messageInputContainerBottomConstraint: NSLayoutConstraint?
    var theme: Theme
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 14))
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        tableView.sectionFooterHeight = 0
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: UIApplication.shared.statusBarFrame.height + 44),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        return tableView
    }()
    
    lazy var messageInputContainer: MessageInputContainer = {
        let messageContainer = MessageInputContainer(theme: theme)
        addSubview(messageContainer)
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        messageInputContainerBottomConstraint = NSLayoutConstraint(item: messageContainer, attribute: .bottom,
                                                                   relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        messageInputContainerBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            messageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageContainer.heightAnchor.constraint(equalToConstant: 80)
        ])

        return messageContainer
    }()
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size))
        applyTheme(theme: theme)
    }
    
    // MARK: - Setup View
    fileprivate func applyTheme(theme: Theme) {
        backgroundColor = theme.themeSettings.backgroundColor
    }
    
    func configureTopView(text: String?, image: UIImage?) -> TopView {
        let viewWithTitle = TopView(theme: self.theme)
        viewWithTitle.frame = CGRect(x: 0, y: 0, width: 236, height: 36)
        viewWithTitle.contentView.backgroundColor = .clear
        viewWithTitle.nameLabel.text = text
        viewWithTitle.configureProfileImage(with: image)
        return viewWithTitle
    }
    
    func configureViewForHeaderInSection(sectionInfo: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 28))
        headerView.backgroundColor = .clear

        let dateLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 3, y: 4, width: UIScreen.main.bounds.width / 3, height: 20))
        dateLabel.layer.cornerRadius = dateLabel.bounds.height / 2
        dateLabel.clipsToBounds = true
        dateLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        dateLabel.textAlignment = .center
        dateLabel.text = sectionInfo

        dateLabel.textColor = theme.themeSettings.tableViewHeaderTextColor
        dateLabel.backgroundColor = theme.themeSettings.tableViewHeaderColor

        headerView.addSubview(dateLabel)
        return headerView
    }
    
    func calculateHeightForRow(withText text: String) -> CGFloat {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 16.0) as Any]
        var estimatedFrame = NSString(string: text + "\t").boundingRect(with: size, options: options, attributes: attr, context: nil)
        if estimatedFrame.width > UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8 {
            let newWidth: CGFloat = UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8
            estimatedFrame.size.height = estimatedFrame.height * estimatedFrame.width / newWidth
            estimatedFrame.size.width = newWidth
        }
        let rect = CGSize(width: frame.width, height: estimatedFrame.height + 42)
        return rect.height
    }
}
