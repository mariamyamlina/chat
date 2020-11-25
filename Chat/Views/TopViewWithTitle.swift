//
//  TopViewWithTitle.swift
//  Chat
//
//  Created by Maria Myamlina on 28.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class TopViewWithTitle: UIView {
    lazy var contentView: UIView = { return UIView() }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Colors.profileImageGreen
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        let currentTheme = Theme.current.themeOptions
        label.textColor = currentTheme.textColor
        label.font = UIFont(name: "SFProText-Semibold", size: 16)
        return label
    }()

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
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10),
            profileImage.widthAnchor.constraint(equalToConstant: 36),
            profileImage.heightAnchor.constraint(equalToConstant: 36),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
