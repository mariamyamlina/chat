//
//  MessageInputContainer.swift
//  Chat
//
//  Created by Maria Myamlina on 01.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class MessageInputContainer: EmblemsView {
    // MARK: - UI
    var theme: Theme
    
    lazy var borderLine: EmblemsView = {
        let line = EmblemsView()
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: topAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return line
    }()
    
    lazy var textField: TextField = {
        let textField = TextField()
        textField.autocapitalizationType = .sentences
        textField.attributedPlaceholder = NSAttributedString(string: "Your message here...",
        attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) as Any,
                     NSAttributedString.Key.foregroundColor: theme.settings.textFieldTextColor])
        textField.textAlignment = .left
        textField.font = UIFont(name: "SFProText-Regular", size: 17)
        textField.borderStyle = .roundedRect
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 17).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        textField.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        textField.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
        return textField
    }()

    lazy var addButton: ButtonWithTouchSize = {
        let button = ButtonWithTouchSize(type: .system)
        button.setImage(UIImage(named: "AddIcon"), for: .normal)

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        return button
    }()
    
    lazy var sendButton: ButtonWithTouchSize = {
        let button = ButtonWithTouchSize(type: .system)
        button.isEnabled = false
        button.isHidden = true
        button.setImage(UIImage(named: "SendIcon"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -31).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }()
    
    // MARK: - Handlers
    var sendHandler: (() -> Void)?
    @objc func sendButtonTapped() { sendHandler?() }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        applyTheme(theme: theme)
    }
    
    // MARK: - Setup View
    func enableSendButton(_ state: Bool) {
        sendButton.isHidden = !state
        sendButton.isEnabled = state
    }
    
    private func applyTheme(theme: Theme) {
        self.theme = theme
        backgroundColor = theme.settings.barColor
        borderLine.backgroundColor = Colors.separatorColor()
        textField.backgroundColor = theme.settings.textFieldBackgroundColor
        if #available(iOS 13.0, *) {
        } else {
            textField.keyboardAppearance = theme.settings.keyboardAppearance
            textField.textColor = theme.settings.textColor
        }
    }
}
