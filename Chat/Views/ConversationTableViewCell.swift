//
//  ConversationTableViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    struct ConversationCellModel {
        let name: String
        let message: String?
        let date: Date?
        let image: UIImage?
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 24
        image.clipsToBounds = true
        image.backgroundColor = Colors.profileImageGreen
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "SFProText-Regular", size: 15.0)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "SFProText-Regular", size: 15.0)
        return label
    }()
    
    lazy var onlineIndicator: UIView = {
        let indicator = UIView()
        indicator.layer.cornerRadius = 9
        indicator.clipsToBounds = true
        indicator.layer.borderWidth = 3
        return indicator
    }()
    
    static let reuseIdentifier = "Conversation Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        onlineIndicator.backgroundColor = Colors.onlineIndicatorGreen
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        onlineIndicator.backgroundColor = Colors.onlineIndicatorGreen
    }
    
    // MARK: - View
    
    func setupView() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(dateLabel)
        addSubview(onlineIndicator)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        onlineIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageBottomConstraint = NSLayoutConstraint(item: profileImage, attribute: .bottom, relatedBy: .equal,
                                                              toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
        let nameLabelBottomConstraint = NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal,
                                                           toItem: messageLabel, attribute: .top, multiplier: 1, constant: 0)
        let nameLabelHeightConstraint = NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal,
                                                           toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        [profileImageBottomConstraint, nameLabelBottomConstraint, nameLabelHeightConstraint].forEach {
            $0.priority = UILayoutPriority(rawValue: 999)
            $0.isActive = true
        }
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: onlineIndicator.topAnchor, constant: 1),
            profileImage.bottomAnchor.constraint(equalTo: onlineIndicator.bottomAnchor, constant: 29),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.5),
            profileImage.leadingAnchor.constraint(equalTo: onlineIndicator.leadingAnchor, constant: -34),
            profileImage.trailingAnchor.constraint(equalTo: onlineIndicator.trailingAnchor, constant: -4),
            profileImage.trailingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12.5),
            profileImage.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -12.5),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -6),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        backgroundColor = .clear
    }
    
    fileprivate func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        nameLabel.textColor = currentTheme.textColor
        messageLabel.textColor = currentTheme.messageLabelColor
        dateLabel.textColor = currentTheme.messageLabelColor
        onlineIndicator.layer.borderColor = currentTheme.backgroundColor.cgColor
    }
}

// MARK: - Configuration

extension ConversationTableViewCell: ConfigurableViewProtocol {
    func configure(with model: ConversationCellModel) {
        profileImage.image = model.image
        nameLabel.text = model.name
        onlineIndicator.isHidden = !model.isOnline

        if let message = model.message, let date = model.date {
            messageLabel.text = message
            dateLabel.text = dateFormatter(date: date, force: false) + "  >"
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
        
        applyTheme()
    }
}
