//
//  ThemeButton.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

@IBDesignable
class ThemeButton: ButtonWithTouchSize {
    
    var pickHandler: (() -> Void)?
    
    @IBInspectable var inputMessageColor: UIColor = Colors.inputGray {
        didSet {
            inputMessageBubble.backgroundColor = inputMessageColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var outputMessageColor: UIColor = Colors.outputGreen {
        didSet {
            outputMessageBubble.backgroundColor = outputMessageColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var backgroundViewColor: UIColor = .white {
        didSet {
            backgroundView.backgroundColor = backgroundViewColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var labelTitle: String = "Classic" {
        didSet {
            let attr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProText-Semibold", size: 19) as Any]
            let attrString = NSMutableAttributedString(string: labelTitle, attributes: attr)
            themeNameLabel.attributedText = attrString
            setNeedsDisplay()
        }
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var themeNameLabel: UILabel!
    @IBOutlet weak var inputMessageBubble: UIView!
    @IBOutlet weak var outputMessageBubble: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let bundle = Bundle(for: ThemeButton.self)
        bundle.loadNibNamed("ThemeButton", owner: self, options: nil)
        
        contentView.backgroundColor = .clear
        addSubview(contentView)
        contentView.isUserInteractionEnabled = false
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        themeNameLabel.textColor = .white
        
        layer.cornerRadius = 14
        clipsToBounds = true
        backgroundView.layer.cornerRadius = 14
        backgroundView.clipsToBounds = true
        inputMessageBubble.layer.cornerRadius = 8
        inputMessageBubble.clipsToBounds = true
        outputMessageBubble.layer.cornerRadius = 8
        outputMessageBubble.clipsToBounds = true

        addTarget(self, action: #selector(pickButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func pickButtonTapped(_ sender: ThemeButton) {
        pickHandler?()
    }
}
