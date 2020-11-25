//
//  ThemeButton.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemeButton: ButtonWithTouchSize {
    var pickHandler: (() -> Void)?
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        return contentView
    }()
    
    lazy var themeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Semibold", size: 19)
        return label
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 14
        backgroundView.clipsToBounds = true
        return backgroundView
    }()
    
    lazy var inputMessageBubble: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 8
        bubble.clipsToBounds = true
        return bubble
    }()
    
    lazy var outputMessageBubble: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 8
        bubble.clipsToBounds = true
        return bubble
    }()
    
    var inputMessageColor: UIColor = Colors.inputGray {
        didSet {
            inputMessageBubble.backgroundColor = inputMessageColor
            setNeedsDisplay()
        }
    }
    
    var outputMessageColor: UIColor = Colors.outputGreen {
        didSet {
            outputMessageBubble.backgroundColor = outputMessageColor
            setNeedsDisplay()
        }
    }
    
    var backgroundViewColor: UIColor = .white {
        didSet {
            backgroundView.backgroundColor = backgroundViewColor
            setNeedsDisplay()
        }
    }
    
    var labelTitle: String = "Classic" {
        didSet {
            themeNameLabel.text = labelTitle
            setNeedsDisplay()
        }
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
        addSubview(contentView)
        contentView.addSubview(themeNameLabel)
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(inputMessageBubble)
        backgroundView.addSubview(outputMessageBubble)

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        contentView.translatesAutoresizingMaskIntoConstraints = false
        themeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        inputMessageBubble.translatesAutoresizingMaskIntoConstraints = false
        outputMessageBubble.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: themeNameLabel.topAnchor, constant: -20),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            themeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            themeNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            inputMessageBubble.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 14),
            inputMessageBubble.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -18),
            inputMessageBubble.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30),
            inputMessageBubble.trailingAnchor.constraint(equalTo: outputMessageBubble.leadingAnchor, constant: -6),
            inputMessageBubble.widthAnchor.constraint(equalToConstant: 117),
            outputMessageBubble.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 22),
            outputMessageBubble.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            outputMessageBubble.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30),
            outputMessageBubble.widthAnchor.constraint(equalToConstant: 117)
        ])
        
        layer.cornerRadius = 14
        clipsToBounds = true
        addTarget(self, action: #selector(pickButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func pickButtonTapped(_ sender: ThemeButton) {
        pickHandler?()
    }
}
