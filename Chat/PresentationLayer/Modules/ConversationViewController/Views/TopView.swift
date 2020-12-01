//
//  TopView.swift
//  Chat
//
//  Created by Maria Myamlina on 28.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class TopView: UIView {
    // MARK: - UI
    let theme: Theme
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return contentView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = theme.settings.textColor
        label.font = UIFont(name: "SFProText-Semibold", size: 16)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
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
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
    }
}
