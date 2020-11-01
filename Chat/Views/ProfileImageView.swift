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
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = false
        return contentView
    }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.profileImageGreen
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var lettersLabel: UILabel = {
        let label = UILabel()
        let letters = getLetters(for: ProfileViewController.name ?? "")
        label.text = letters
        label.font = UIFont(name: "Roboto-Regular", size: fontSize)
        label.textColor = Colors.lettersLabelColor
        label.textAlignment = .center
        return label
    }()
    
    var profileImageWidthConstraint: NSLayoutConstraint?
    var profileImageHeightConstraint: NSLayoutConstraint?
    var lettersLabelWidthConstraint: NSLayoutConstraint?
    var lettersLabelHeightConstraint: NSLayoutConstraint?
    
    var initials: String?
    var fontSize: CGFloat = 120
    
    private var touchPath: UIBezierPath { return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            profileImageWidthConstraint?.constant = 40
            profileImageHeightConstraint?.constant = 40
            lettersLabelWidthConstraint?.constant = 36
            lettersLabelHeightConstraint?.constant = 18
            
            fontSize = 20
        } else {
            profileImageWidthConstraint?.constant = 240
            profileImageHeightConstraint?.constant = 240
            lettersLabelWidthConstraint?.constant = 220
            lettersLabelHeightConstraint?.constant = 110

            fontSize = 120
        }
        
        lettersLabel.font = lettersLabel.font.withSize(fontSize)
        layer.cornerRadius = (profileImageWidthConstraint?.constant ?? 0) / 2
        clipsToBounds = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }
    
    func setupView() {
        addSubview(contentView)
        contentView.addSubview(profileImage)
        profileImage.addSubview(lettersLabel)

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        contentView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        lettersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageWidthConstraint = NSLayoutConstraint(item: profileImage, attribute: .width, relatedBy: .equal,
                                                         toItem: nil, attribute: .width, multiplier: 1, constant: 240)
        profileImageHeightConstraint = NSLayoutConstraint(item: profileImage, attribute: .height, relatedBy: .equal,
                                                          toItem: nil, attribute: .height, multiplier: 1, constant: 240)
        lettersLabelWidthConstraint = NSLayoutConstraint(item: lettersLabel, attribute: .width, relatedBy: .greaterThanOrEqual,
                                                         toItem: nil, attribute: .width, multiplier: 1, constant: 220)
        lettersLabelHeightConstraint = NSLayoutConstraint(item: lettersLabel, attribute: .height, relatedBy: .equal,
                                                          toItem: nil, attribute: .height, multiplier: 1, constant: 110)
        profileImageWidthConstraint?.isActive = true
        profileImageHeightConstraint?.isActive = true
        lettersLabelWidthConstraint?.isActive = true
        lettersLabelHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lettersLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            lettersLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])

        loadFromFile(with: GCDDataManager.shared)
//        loadFromFile(with: OperationDataManager.shared)
        
        if profileImage.image != nil {
            lettersLabel.isHidden = true
        }
        layer.cornerRadius = (profileImageWidthConstraint?.constant ?? 0) / 2
        clipsToBounds = true
    }
    
    private func loadFromFile(with dataManager: DataManagerProtocol) {
        dataManager.loadFromFile(mustReadName: true, mustReadBio: false, mustReadImage: true, completion: loadImageCompletion(_:_:_:))
    }
    
    func loadImageCompletion(_ mustOverwriteName: Bool, _ mustOverwriteBio: Bool, _ mustOverwriteImage: Bool) {
        if mustOverwriteName {
            lettersLabel.text = getLetters(for: ProfileViewController.name ?? "")
        }
        if mustOverwriteImage {
            updateImage()
        }
    }
    
    private func getLetters(for text: String) -> String {
        let lettersArray = text.components(separatedBy: .whitespaces)
        if lettersArray.count == 2 {
            let letters = [String(lettersArray[0].first ?? "M"), String(lettersArray[1].first ?? "D")]
            initials = letters[0] + letters[1]
        } else {
            initials = ""
        }
        return initials ?? ""
    }
    
    func updateImage() {
        if let existingImage = ProfileViewController.image {
            profileImage.image = existingImage
        }
        if profileImage.image != nil {
            lettersLabel.isHidden = true
        }
    }
}
