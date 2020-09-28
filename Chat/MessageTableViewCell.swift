//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 26.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    struct MessageCellModel {
        let text: String
    }
    
    lazy var messageTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        textView.font = UIFont(name: "SFProText-Regular", size: 16.0)
        return textView
    }()
    
    lazy var textBubbleView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "22:22"
        label.font = UIFont(name: "SFProText-Regular", size: 11.0)
        label.textAlignment = .right
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(timeLabel)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textBubbleView.topAnchor.constraint(equalTo: messageTextView.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -16),
            timeLabel.trailingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: -8),
            timeLabel.heightAnchor.constraint(equalToConstant: 13),
            timeLabel.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
}

extension MessageTableViewCell: ConfigurableView {
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: ConfigurationModel) {
        
        messageTextView.text = model.text
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: model.text + "date").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 16.0) as Any], context: nil)

        if estimatedFrame.width > UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8 {
            estimatedFrame.size.width = UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8
        }
        
        if messageTextView.backgroundColor == UIColor(red: 220/250, green: 247/250, blue: 197/250, alpha: 1) {
            messageTextView.frame = CGRect(x: UIScreen.main.bounds.width - 28 - estimatedFrame.width - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            textBubbleView.frame = CGRect(x: UIScreen.main.bounds.width - 20 - estimatedFrame.width - 16 - 8, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 26)
        } else {
            messageTextView.frame = CGRect(x: 28, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            textBubbleView.frame = CGRect(x: 20, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 26)
        }
    }
}
