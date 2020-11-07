//
//  MessageInputContainer.swift
//  Chat
//
//  Created by Maria Myamlina on 01.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class MessageInputContainer: UIView {
    var sendHandler: (() -> Void)?
    @objc func sendButtonTapped() { sendHandler?() }
    
    lazy var borderLine: UIView = {
        let line = UIView()
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: topAnchor),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return line
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .sentences
        let currentTheme = Theme.current.themeOptions
        textField.attributedPlaceholder = NSAttributedString(string: "Your message here...",
        attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any, NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        textField.textAlignment = .left
        textField.font = UIFont(name: "SFProText-Regular", size: 17)
        textField.borderStyle = .roundedRect

        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            textField.heightAnchor.constraint(equalToConstant: 32)
        ])
        return textField
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "AddIcon"), for: .normal)

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.isHidden = true
        button.setImage(UIImage(named: "SendIcon"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textField.topAnchor, constant: 2),
            button.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -6),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -31),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24)
        ])
        return button
    }()
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyTheme()
    }
    
    func enableSendButton(_ state: Bool) {
        sendButton.isHidden = !state
        sendButton.isEnabled = state
    }
    
    // MARK: - Theme
    
    private func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        backgroundColor = currentTheme.barColor
        borderLine.backgroundColor = Colors.separatorColor()
        textField.backgroundColor = currentTheme.textFieldBackgroundColor
        if #available(iOS 13.0, *) {
        } else {
            textField.keyboardAppearance = currentTheme.keyboardAppearance
            textField.textColor = currentTheme.textColor
        }
    }
}
