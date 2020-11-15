//
//  CollectionViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 13.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class CollectionViewController: LogViewController {
    // MARK: - UI
    lazy var collectionView = CollectionView(theme: model.currentTheme)
    
    // MARK: - Dependencies
    private let presentationAssembly: IPresentationAssembly
    private let model: ICollectionModel
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: ICollectionModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(model: presentationAssembly.logModel())
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createHandlers()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: - Не учитывается NavigationBar
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = collectionView.rightBarButtonItem
    }
    
    // MARK: - Handlers
    private func createHandlers() {
        collectionView.collectionView.delegate = self
        collectionView.collectionView.dataSource = self

        collectionView.closeCollectionHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // TODO
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as? CollectionViewCell
        return cell ?? CollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = (collectionView.frame.width - 16) / 3
        return CGSize(width: constant, height: constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
