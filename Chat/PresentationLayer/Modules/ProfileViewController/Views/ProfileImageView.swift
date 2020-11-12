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
    // MARK: - UI
    var profileImageWidthConstraint, profileImageHeightConstraint: NSLayoutConstraint?
    var lettersLabelWidthConstraint, lettersLabelHeightConstraint: NSLayoutConstraint?
    
    var initials: String?
    var fontSize: CGFloat = 120
    var name: String?
    var image: UIImage?
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = false
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return contentView
    }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.profileImageGreen
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        return imageView
    }()
    
    lazy var lettersLabel: UILabel = {
        let label = UILabel()
        let letters = getLetters(for: name ?? "")
        label.text = letters
        label.font = UIFont(name: "Roboto-Regular", size: fontSize)
        label.textColor = Colors.lettersLabelColor
        label.textAlignment = .center
        profileImage.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        return label
    }()
    
    private var touchPath: UIBezierPath {
        return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(small: Bool, name: String?, image: UIImage?) {
        self.name = name
        self.image = image
        super.init(frame: CGRect.zero)
        createConstraints()
        
        if small {
            profileImageWidthConstraint?.constant = 40
            profileImageHeightConstraint?.constant = 40
            lettersLabelWidthConstraint?.constant = 36
            lettersLabelHeightConstraint?.constant = 18
            fontSize = 20
        }

        layer.cornerRadius = (profileImageWidthConstraint?.constant ?? 0) / 2
        clipsToBounds = true
        lettersLabel.font = lettersLabel.font.withSize(fontSize)
        lettersLabel.isHidden = (profileImage.image != nil)
    }
    
    // MARK: - Setup View
    func createConstraints() {
        profileImageWidthConstraint = NSLayoutConstraint(item: profileImage, attribute: .width, relatedBy: .equal,
                                                         toItem: nil, attribute: .width, multiplier: 1, constant: 240)
        profileImageHeightConstraint = NSLayoutConstraint(item: profileImage, attribute: .height, relatedBy: .equal,
                                                          toItem: nil, attribute: .height, multiplier: 1, constant: 240)
        lettersLabelWidthConstraint = NSLayoutConstraint(item: lettersLabel, attribute: .width, relatedBy: .greaterThanOrEqual,
                                                         toItem: nil, attribute: .width, multiplier: 1, constant: 220)
        lettersLabelHeightConstraint = NSLayoutConstraint(item: lettersLabel, attribute: .height, relatedBy: .equal,
                                                          toItem: nil, attribute: .height, multiplier: 1, constant: 110)
        [profileImageWidthConstraint, profileImageHeightConstraint, lettersLabelWidthConstraint, lettersLabelHeightConstraint].forEach { $0?.isActive = true }
    }
    
    func loadImageCompletion(name: String?, image: UIImage?) {
        self.name = name
        self.image = image
        lettersLabel.text = getLetters(for: name ?? "")
        profileImage.image = image
        lettersLabel.isHidden = (profileImage.image != nil)
    }
    
    private func getLetters(for text: String) -> String {
        let lettersArray = text.components(separatedBy: .whitespaces)
        initials = ""
        if lettersArray.count == 2 {
            let letters = [String(lettersArray[0].first ?? "M"), String(lettersArray[1].first ?? "D")]
            initials = letters[0] + letters[1]
        }
        return initials ?? ""
    }
}
