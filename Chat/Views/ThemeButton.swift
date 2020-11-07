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
    @objc func pickButtonTapped(_ sender: ThemeButton) { pickHandler?() }
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        return contentView
    }()
    
    lazy var themeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Semibold", size: 19)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        return label
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 14
        backgroundView.clipsToBounds = true
        
        contentView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: themeNameLabel.topAnchor, constant: -20),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        return backgroundView
    }()
    
    lazy var inputMessageBubble: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 8
        bubble.clipsToBounds = true
        
        backgroundView.addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 14),
            bubble.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -18),
            bubble.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30),
            bubble.trailingAnchor.constraint(equalTo: outputMessageBubble.leadingAnchor, constant: -6),
            bubble.widthAnchor.constraint(equalToConstant: 117)
        ])
        return bubble
    }()
    
    lazy var outputMessageBubble: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 8
        bubble.clipsToBounds = true
        
        backgroundView.addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 22),
            bubble.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            bubble.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30),
            bubble.widthAnchor.constraint(equalToConstant: 117)
        ])
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
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    init(title: String, backgroundColor: UIColor, inputColor: UIColor, outputColor: UIColor) {
        super.init(frame: CGRect.zero)
        labelTitle = title
        backgroundViewColor = backgroundColor
        inputMessageColor = inputColor
        outputMessageColor = outputColor
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 14
        clipsToBounds = true
        addTarget(self, action: #selector(pickButtonTapped(_:)), for: .touchUpInside)
    }
}
