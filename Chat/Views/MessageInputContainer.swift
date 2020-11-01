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
        let button = UIButton(type: .custom)
        button.tintColor = .systemBlue
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isEnabled = false
        button.isHidden = true
        button.tintColor = .systemBlue
        button.setImage(UIImage(named: "SendIcon"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func sendButtonTapped(_ sender: ThemeButton) {
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
            borderLine.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            borderLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            borderLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            borderLine.heightAnchor.constraint(equalToConstant: 0.5),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            textField.heightAnchor.constraint(equalToConstant: 32),
            addButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -37),
            sendButton.heightAnchor.constraint(equalToConstant: 18),
            sendButton.widthAnchor.constraint(equalToConstant: 18)
        ])

        applyTheme()
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
