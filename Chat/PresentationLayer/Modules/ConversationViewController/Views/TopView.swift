//
//  TopView.swift
//  Chat
//
//  Created by Maria Myamlina on 28.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class TopView: UIView {
    let theme: Theme
    
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
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = theme.themeSettings.textColor
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
    
    func configureProfileImage(with image: UIImage?) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Colors.profileImageGreen
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.image = image

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
    }
    
    required init?(coder: NSCoder) {
        self.theme = .classic
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
    }
}
