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
    
    static var letters: String? = nil
    static var fontSize: CGFloat = 120
    
    private var touchPath: UIBezierPath {return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)}
    
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
        
        layer.cornerRadius = profileImageWidthConstraint.constant / 2
        clipsToBounds = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }
    
    func setupView() {
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
        
        profileImageWidthConstraint.constant = 240
        profileImageHeightConstraint.constant = 240
        lettersLabelWidthConstraint.constant = 220
        lettersLabelHeightConstraint.constant = 110
        
        //Считываю с помощью GCD
        readFromFile(with: .gcd)
        
        profileImage.contentMode = .scaleAspectFill

        let letters = getLetters(for: ProfileViewController.name ?? "Marina Dudarenko")
        lettersLabel.text = letters
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Roboto-Regular", size: ProfileImageView.fontSize) as Any]
        let attrString = NSMutableAttributedString(string: letters, attributes: attr)
        lettersLabel.attributedText = attrString
        lettersLabel.textColor = Colors.lettersLabelColor
        
        layer.cornerRadius = profileImageWidthConstraint.constant / 2
        clipsToBounds = true
    }
    
    func readFromFile(with dataManager: ProfileViewController.DataManagerType) {
        if dataManager == .gcd {
            let gcdDataManager = GCDDataManager()
            gcdDataManager.readFromFile(mustReadName: true, mustReadBio: false, mustReadImage: true)
//            gcdDataManager.readNameFromFile()
//            gcdDataManager.readImageFromFile()
        } else {
            let operationDataManager = OperationDataManager()
            operationDataManager.readNameFromFile()
            operationDataManager.readImageFromFile()
        }
        updateImage()
    }
    
    func getLetters(for text: String) -> String {
        let lettersArray = text.components(separatedBy: .whitespaces)
        if lettersArray.count == 2 {
            let letters = [String(lettersArray[0].first ?? "M"), String(lettersArray[1].first ?? "D")]
            ProfileImageView.letters = letters[0] + letters[1]
            return letters[0] + letters[1]
        } else {
            ProfileImageView.letters = "MD"
            return "MD"
        }
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
