//
//  ProfileImageView.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileImageView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lettersLabel: UILabel!
    @IBOutlet weak var profileImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lettersLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lettersLabelHeightConstraint: NSLayoutConstraint!
    
    static var fontSize: CGFloat = 120
    
    private var touchPath: UIBezierPath {return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    init(small: Bool) {
        super.init(frame: CGRect.zero)
        setupView()
        
        if small {
            profileImageWidthConstraint.constant = 40
            profileImageHeightConstraint.constant = 40
            lettersLabelWidthConstraint.constant = 36
            lettersLabelHeightConstraint.constant = 18
            
            ProfileImageView.fontSize = 20
        } else {
            profileImageWidthConstraint.constant = 240
            profileImageHeightConstraint.constant = 240
            lettersLabelWidthConstraint.constant = 220
            lettersLabelHeightConstraint.constant = 110

            ProfileImageView.fontSize = 120
        }
        
        lettersLabel.font = lettersLabel.font.withSize(ProfileImageView.fontSize)
        ProfileImageView.fontSize = 120
    }
    
    private func setupView() {
        let bundle = Bundle(for: ProfileImageView.self)
        bundle.loadNibNamed("ProfileImageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.isUserInteractionEnabled = false
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(profileImage)
        profileImage.addSubview(lettersLabel)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        lettersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        profileImage.contentMode = .scaleAspectFill

        let letters = ProfileViewController.letters
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Roboto-Regular", size: ProfileImageView.fontSize) as Any]
        let attrString = NSMutableAttributedString(string: letters, attributes: attr)
        lettersLabel.attributedText = attrString
        lettersLabel.textColor = Colors.lettersLabelColor
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }
}
