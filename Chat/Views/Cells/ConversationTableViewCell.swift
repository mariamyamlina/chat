//
//  MessageTableViewCell.swift
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
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var onlineIndicator: UIView!
    
    static let reuseIdentifier = "Conversation Cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setOnlineIndicatorColor()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setOnlineIndicatorColor()
    }
    
    // MARK: - View
    
    func setupView() {
        profileImage.contentMode = .scaleAspectFill
        setOnlineIndicatorColor()
        onlineIndicator.layer.borderWidth = 3
        onlineIndicator.layer.borderColor = UIColor.white.cgColor
    }
    
    func setOnlineIndicatorColor() {
        onlineIndicator.backgroundColor = Colors.brightGreen
    }
    
    func configureImageSubview() -> UIImageView {
        guard let subview = profileImage else { return UIImageView() }
        subview.translatesAutoresizingMaskIntoConstraints = false

        let viewWithImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))

        viewWithImage.clipsToBounds = true
        viewWithImage.image = subview.image
        viewWithImage.addSubview(subview)

        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: viewWithImage.topAnchor),
            subview.bottomAnchor.constraint(equalTo: viewWithImage.bottomAnchor),
            subview.trailingAnchor.constraint(equalTo: viewWithImage.trailingAnchor),
            subview.leadingAnchor.constraint(equalTo: viewWithImage.leadingAnchor),
            subview.heightAnchor.constraint(equalToConstant: 36),
            subview.widthAnchor.constraint(equalToConstant: 36)
        ])        
        return viewWithImage
    }
    
}

// MARK: - Configuration

extension ConversationTableViewCell: ConfigurableView {
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConfigurationModel) {
        backgroundColor = .clear
        
        profileImage.backgroundColor = Colors.profileImageGreen
        profileImage.image = generateImage()
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
    }
    
}
