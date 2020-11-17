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
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ImagePlaceholder"))
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
    
    // MARK: - Setup View
    func getImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        self.imageView.image = UIImage(named: "ImagePlaceholder")
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
    
    func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }
}
