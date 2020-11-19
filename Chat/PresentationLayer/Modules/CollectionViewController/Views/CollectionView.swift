//
//  CollectionView.swift
//  Chat
//
//  Created by Maria Myamlina on 13.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class CollectionView: UIView {
    // MARK: - UI
    var theme: Theme
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        bringSubviewToFront(activityIndicator)
        return collectionView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.color = theme.settings.textColor
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return activityIndicator
    }()
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self,
                                                 action: #selector(closeCollectionViewController))
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 17) as Any]
        rightBarButtonItem.setTitleTextAttributes(attr, for: .normal)
        rightBarButtonItem.setTitleTextAttributes(attr, for: .highlighted)
        return rightBarButtonItem
    }()
    
    // MARK: - Handlers
    var closeCollectionHandler: (() -> Void)?
    @objc func closeCollectionViewController() { closeCollectionHandler?() }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    // MARK: - Setup View
    func setupView() {
        backgroundColor = theme.settings.backgroundColor
        activityIndicator.startAnimating()
    }
    
    func reloadData() {
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func activateTopConstraint(with constant: CGFloat) {
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8 + constant).isActive = true
    }
}
