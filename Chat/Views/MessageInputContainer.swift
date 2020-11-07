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
    
    lazy var borderLine: UIView = { return UIView() }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .sentences
        let currentTheme = Theme.current.themeOptions
        textField.attributedPlaceholder = NSAttributedString(string: "Your message here...",
        attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any, NSAttributedString.Key.foregroundColor: currentTheme.textFieldTextColor])
        textField.textAlignment = .left
        textField.font = UIFont(name: "SFProText-Regular", size: 17)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.isHidden = true
        button.setImage(UIImage(named: "SendIcon"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func sendButtonTapped() {
        sendHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(borderLine)
        addSubview(textField)
        addSubview(addButton)
        addSubview(sendButton)
        
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            borderLine.topAnchor.constraint(equalTo: topAnchor),
            borderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 0.5),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            textField.heightAnchor.constraint(equalToConstant: 32),
            addButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.topAnchor.constraint(equalTo: textField.topAnchor, constant: 2),
            sendButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -6),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -31),
            sendButton.heightAnchor.constraint(equalToConstant: 24),
            sendButton.widthAnchor.constraint(equalToConstant: 24)
        ])

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
