//
//  ConversationTableViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

class ConversationTableViewCell: UITableViewCell {
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
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: onlineIndicator.topAnchor, constant: 1),
            profileImage.bottomAnchor.constraint(equalTo: onlineIndicator.bottomAnchor, constant: 29),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.5),
            profileImage.leadingAnchor.constraint(equalTo: onlineIndicator.leadingAnchor, constant: -34),
            profileImage.trailingAnchor.constraint(equalTo: onlineIndicator.trailingAnchor, constant: -4),
            profileImage.trailingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12.5),
            profileImage.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -12.5)
        ])
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
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76),
            label.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -6)
        ])
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "SFProText-Regular", size: 15.0)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.widthAnchor.constraint(equalToConstant: 70)
        ])
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
    
    static let reuseIdentifier = "Conversation Cell"
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { super.init(style: style, reuseIdentifier: reuseIdentifier) }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        onlineIndicator.backgroundColor = Colors.onlineIndicatorGreen
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        onlineIndicator.backgroundColor = Colors.onlineIndicatorGreen
    }
    
    fileprivate func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        backgroundColor = .clear
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