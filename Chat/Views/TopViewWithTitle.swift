//
//  TopViewWithTitle.swift
//  Chat
//
//  Created by Maria Myamlina on 28.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class TopViewWithTitle: UIView {
    lazy var contentView: UIView = {
        let contentView = UIView()
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
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Colors.profileImageGreen
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36)
        ])
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        let currentTheme = Theme.current.themeOptions
        label.textColor = currentTheme.textColor
        label.font = UIFont(name: "SFProText-Semibold", size: 16)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        return label
    }()
    
    required init?(coder: NSCoder) { super.init(coder: coder) }

    override init(frame: CGRect) { super.init(frame: frame) }
}
