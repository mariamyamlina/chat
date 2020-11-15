//
//  CollectionViewCell.swift
//  Chat
//
//  Created by Maria Myamlina on 14.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    // MARK: - UI
    lazy var view: UIView = {
        // TODO
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "ImagePlaceholder"))
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return view
    }()
    
    // MARK: - Init / deinit
    static let reuseIdentifier = "Collection Cell"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        // TODO
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
//        let imageView = UIImageView(image: UIImage(named: "ImagePlaceholder"))
//        imageView.contentMode = .scaleToFill
//        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        view.addSubview(imageView)
//        view.bringSubviewToFront(imageView)
        backgroundView = view
    }
}
