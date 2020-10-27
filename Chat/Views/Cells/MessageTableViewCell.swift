//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 26.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    enum MessageType {
        case input
        case output
    }
    
    struct MessageCellModel {
        let text: String
        let time: Date
        let type: MessageType
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
        let messageText = model.text
        timeLabel.text = dateFormatter(date: model.time, force: true)

        if let index = messageText.firstIndex(of: "\n"), model.type == .input {
            let nameSubstring = String(messageText[..<index])
            let messageSubstring = String(messageText[index...])
            let attrsBold = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 16) as Any]
            let attributedString = NSMutableAttributedString(string: nameSubstring, attributes: attrsBold)
            let attrsRegular = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 16) as Any]
            let messageString = NSMutableAttributedString(string: messageSubstring, attributes: attrsRegular)
            attributedString.append(messageString)
            messageTextView.attributedText = attributedString
        } else {
            messageTextView.text = messageText
        }
        
        backgroundColor = .clear
        selectionStyle = .none

        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 16.0) as Any]
        var estimatedFrame = NSString(string: model.text + "\t").boundingRect(with: size, options: options, attributes: attr, context: nil)

        if estimatedFrame.width > UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8 {
            let newWidth: CGFloat = UIScreen.main.bounds.width * 0.75 - 20 - 16 - 8
            estimatedFrame.size.height = estimatedFrame.height * estimatedFrame.width / newWidth
            estimatedFrame.size.width = newWidth
        }
        
        let estimatedHeight = estimatedFrame.height
        let estimatedWidth = estimatedFrame.width
        
        if textBubbleView.backgroundColor == currentTheme.outputBubbleColor {
            messageTextView.textColor = currentTheme.outputTextColor
            timeLabel.textColor = currentTheme.outputTimeColor
            messageTextView.frame = CGRect(x: UIScreen.main.bounds.width - 28 - estimatedWidth - 16, y: 0, width: estimatedWidth + 16, height: estimatedHeight + 28)
            textBubbleView.frame = CGRect(x: UIScreen.main.bounds.width - 20 - estimatedWidth - 16 - 8, y: 0, width: estimatedWidth + 16 + 8, height: estimatedHeight + 28)
        } else {
            messageTextView.textColor = currentTheme.textColor
            print(currentTheme.inputTimeColor)
            timeLabel.textColor = currentTheme.inputTimeColor
            messageTextView.frame = CGRect(x: 28, y: 0, width: estimatedWidth + 16, height: estimatedHeight + 28)
            textBubbleView.frame = CGRect(x: 20, y: 0, width: estimatedWidth + 16 + 8, height: estimatedHeight + 28)
        }
    }
}
