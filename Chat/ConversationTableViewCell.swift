//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

class ConversationTableViewCell: UITableViewCell {
    
    struct ConversationCellModel {
        let name: String
        let message: String
        let date: Date
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2
        profileImage.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Configuration

extension ConversationTableViewCell: ConfigurableView {
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConfigurationModel) {
        
        profileImage.image = UIImage(named: model.name)
        nameLabel.text = model.name
        
        if model.isOnline {
            backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.1548319778)
        } else {
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if model.message == "" {
            messageLabel.text = "No messages yet"
            dateLabel.text = ">"
            messageLabel.font = .italicSystemFont(ofSize: 13.0)
        } else {
            messageLabel.text = model.message
            dateLabel.text = dateFormatter(date: model.date, force: false) + "  >"
            if model.hasUnreadMessages == true {
                messageLabel.font = UIFont(name: "SFProText-Semibold", size: 13.0)
            } else {
                messageLabel.font = UIFont(name: "SFProText-Regular", size: 13.0)
            }
        }
    }
    
}
