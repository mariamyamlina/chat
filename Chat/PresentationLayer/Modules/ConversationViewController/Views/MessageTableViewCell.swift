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
    
    static let reuseIdentifier = "Message Cell"
    
    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        textView.font = UIFont(name: "SFProText-Regular", size: 16.0)
        addSubview(textView)
        return textView
    }()
    
    lazy var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        addSubview(view)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "22:22"
        label.font = UIFont(name: "SFProText-Regular", size: 11.0)
        label.textAlignment = .right
        
        textBubbleView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -2),
            label.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 13),
            label.widthAnchor.constraint(equalToConstant: 32)
        ])
        return label
    }()
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: - Configuration

extension MessageTableViewCell: ConfigurableViewProtocol {
    func configure(with model: MessageCellModel) {
        let currentTheme = Theme.current.themeOptions
        let messageText = model.text
        timeLabel.text = model.time.dateFormatter(onlyTimeMode: true)

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
        
        if model.type == .output {
            messageTextView.textColor = currentTheme.outputTextColor
            timeLabel.textColor = currentTheme.outputTimeColor
            textBubbleView.backgroundColor = currentTheme.outputBubbleColor
            messageTextView.frame = CGRect(x: UIScreen.main.bounds.width - 28 - estimatedWidth - 16, y: 0, width: estimatedWidth + 16, height: estimatedHeight + 28)
            textBubbleView.frame = CGRect(x: UIScreen.main.bounds.width - 20 - estimatedWidth - 16 - 8, y: 0, width: estimatedWidth + 16 + 8, height: estimatedHeight + 28)
        } else {
            messageTextView.textColor = currentTheme.textColor
            timeLabel.textColor = currentTheme.inputTimeColor
            textBubbleView.backgroundColor = currentTheme.inputBubbleColor
            messageTextView.frame = CGRect(x: 28, y: 0, width: estimatedWidth + 16, height: estimatedHeight + 28)
            textBubbleView.frame = CGRect(x: 20, y: 0, width: estimatedWidth + 16 + 8, height: estimatedHeight + 28)
        }
    }
}
