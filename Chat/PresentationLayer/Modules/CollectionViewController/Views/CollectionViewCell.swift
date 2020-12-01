//
//  CollectionViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 14.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "Collection Cell"
    
    // MARK: - UI
    var placeholder = UIImage(named: "ImagePlaceholder")
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return imageView
    }()
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.image = placeholder
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = placeholder
    }
}

// MARK: - Configuration
extension CollectionViewCell: IConfigurableView {
    func configure(with model: CollectionCellModel, theme: Theme) {
        self.imageView.image = model.image
    }
}
