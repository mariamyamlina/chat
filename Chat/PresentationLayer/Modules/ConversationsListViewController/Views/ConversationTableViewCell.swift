//
//  ConversationTableViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    // MARK: - UI
    lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 24
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = Colors.profileImageGreen
        addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let profileImageBottomConstraint = NSLayoutConstraint(item: profileImage, attribute: .bottom, relatedBy: .equal,
                                                              toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
        profileImageBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        profileImageBottomConstraint.isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: onlineIndicator.topAnchor, constant: 1).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: onlineIndicator.bottomAnchor, constant: 29).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.5).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: onlineIndicator.leadingAnchor, constant: -34).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: onlineIndicator.trailingAnchor, constant: -4).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12.5).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -12.5).isActive = true
        return profileImage
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "SFProText-Regular", size: 15.0)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal,
                                                           toItem: messageLabel, attribute: .top, multiplier: 1, constant: 0)
        let nameLabelHeightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                                                           toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        [nameLabelBottomConstraint, nameLabelHeightConstraint].forEach {
            $0.priority = UILayoutPriority(rawValue: 999)
            $0.isActive = true
        }
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76).isActive = true
        label.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -6).isActive = true
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "SFProText-Regular", size: 15.0)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return label
    }()
    
    lazy var onlineIndicator: UIView = {
        let indicator = UIView()
        indicator.layer.cornerRadius = 9
        indicator.clipsToBounds = true
        indicator.layer.borderWidth = 3
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init / deinit
    static let reuseIdentifier = "Conversation Cell"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    // MARK: - Setup View
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        onlineIndicator.backgroundColor = Colors.onlineIndicatorGreen
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        onlineIndicator.backgroundColor = Colors.onlineIndicatorGreen
    }
    
    fileprivate func applyTheme(theme: Theme) {
        let currentTheme = theme.themeSettings
        backgroundColor = .clear
        nameLabel.textColor = currentTheme.textColor
        messageLabel.textColor = currentTheme.messageLabelColor
        dateLabel.textColor = currentTheme.messageLabelColor
        onlineIndicator.layer.borderColor = currentTheme.backgroundColor.cgColor
    }
}

// MARK: - Configuration
extension ConversationTableViewCell: IConfigurableView {
    func configure(with model: ConversationCellModel, theme: Theme) {
        profileImage.image = model.image
        nameLabel.text = model.name
        onlineIndicator.isHidden = !model.isOnline

        if let message = model.message, let date = model.date {
            messageLabel.text = message
            dateLabel.text = date.dateFormatter(onlyTimeMode: false) + "  >"
            if model.hasUnreadMessages == true {
                messageLabel.font = UIFont(name: "SFProText-Semibold", size: 13.0)
            } else {
                messageLabel.font = UIFont(name: "SFProText-Regular", size: 13.0)
            }
        } else {
            messageLabel.text = "No messages yet"
            dateLabel.text = ">"
            messageLabel.font = UIFont(name: "SFProText-RegularItalic", size: 13.0)
        }
        
        applyTheme(theme: theme)
    }
}
