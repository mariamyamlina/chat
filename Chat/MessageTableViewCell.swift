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
    
    static let reuseIdentifier = "Message Cell"
    
    lazy var messageTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        textView.font = UIFont(name: "SFProText-Regular", size: 16.0)
        return textView
    }()
    
    lazy var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "22:22"
        label.font = UIFont(name: "SFProText-Regular", size: 11.0)
        label.textAlignment = .right
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    func setupViews() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(timeLabel)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -2),
            timeLabel.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: -8),
            timeLabel.heightAnchor.constraint(equalToConstant: 13),
            timeLabel.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
}


// MARK: - Configuration

extension MessageTableViewCell: ConfigurableView {
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: ConfigurationModel) {
        let currentTheme = Theme.current.themeOptions
        
        messageTextView.text = model.text
        
        backgroundColor = .clear
        selectionStyle = .none

        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: model.text + "    ").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 16.0) as Any], context: nil)

        if estimatedFrame.width > UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8 {
            let newWidth: CGFloat = UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8
            estimatedFrame.size.height = estimatedFrame.height * estimatedFrame.width / newWidth
            estimatedFrame.size.width = newWidth
        }
        
        if textBubbleView.backgroundColor == currentTheme.outputBubbleColor {
            messageTextView.textColor = currentTheme.outputTextColor
            timeLabel.textColor = currentTheme.outputTextColor
            messageTextView.frame = CGRect(x: UIScreen.main.bounds.width - 28 - estimatedFrame.width - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 28)
            textBubbleView.frame = CGRect(x: UIScreen.main.bounds.width - 20 - estimatedFrame.width - 16 - 8, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 28)
        } else {
            messageTextView.textColor = currentTheme.inputAndCommonTextColor
            timeLabel.textColor = currentTheme.inputAndCommonTextColor
            messageTextView.frame = CGRect(x: 28, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 28)
            textBubbleView.frame = CGRect(x: 20, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 28)
        }
    }
}
