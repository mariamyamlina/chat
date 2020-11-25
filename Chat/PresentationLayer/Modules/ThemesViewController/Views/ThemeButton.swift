//
//  ThemeButton.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemeButton: ButtonWithTouchSize {
    // MARK: - UI
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return contentView
    }()
    
    lazy var themeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Semibold", size: 19)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        return label
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 14
        backgroundView.clipsToBounds = true
        
        contentView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: themeNameLabel.topAnchor, constant: -20).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        return backgroundView
    }()
    
    lazy var inputMessageBubble: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 8
        bubble.clipsToBounds = true
        
        backgroundView.addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 14).isActive = true
        bubble.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -18).isActive = true
        bubble.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30).isActive = true
        bubble.trailingAnchor.constraint(equalTo: outputMessageBubble.leadingAnchor, constant: -6).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: 117).isActive = true
        return bubble
    }()
    
    lazy var outputMessageBubble: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 8
        bubble.clipsToBounds = true
        
        backgroundView.addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 22).isActive = true
        bubble.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10).isActive = true
        bubble.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: 117).isActive = true
        return bubble
    }()
    
    // MARK: - Handlers
    var pickHandler: (() -> Void)?
    @objc func pickButtonTapped(_ sender: ThemeButton) { pickHandler?() }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(titleLabel: String, backgroundColor: UIColor, inputColor: UIColor, outputColor: UIColor) {
        super.init(frame: CGRect.zero)
        themeNameLabel.text = titleLabel
        backgroundView.backgroundColor = backgroundColor
        inputMessageBubble.backgroundColor = inputColor
        outputMessageBubble.backgroundColor = outputColor
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        layer.cornerRadius = 14
        clipsToBounds = true
        addTarget(self, action: #selector(pickButtonTapped(_:)), for: .touchUpInside)
    }
}
