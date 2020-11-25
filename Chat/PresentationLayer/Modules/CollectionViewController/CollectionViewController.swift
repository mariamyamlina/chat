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
    
    // DisplayModel
    private var dataSource: [CellDisplayModel] = []
    
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
        setupFetching()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard var constant = navigationController?.navigationBar.bounds.height else { return }
        if #available(iOS 13.0, *) { } else { constant += 20 }
        collectionView.activateTopConstraint(with: constant)
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = collectionView.rightBarButtonItem
        navigationItem.title = "Choose photo"
        navigationController?.navigationBar.addGestureRecognizer(collectionView.animator.gestureRecognizer)
    }
    
    // MARK: - Handlers
    private func createHandlers() {
        navigationController?.view.addGestureRecognizer(collectionView.animator.gestureRecognizer)
        
        collectionView.collectionView.delegate = self
        collectionView.collectionView.dataSource = self

        collectionView.closeCollectionHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupFetching() {
        model.delegate = self
        model.fetchImages()
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: dataSource[indexPath.row].imageUrl) {
            model.fetchImage(with: url) { [weak self] (model, _) in
                guard let pickedImage = model.image else { return }
                let navigationVC = self?.presentingViewController as? UINavigationController
                guard let profileVC = navigationVC?.viewControllers.first as? ProfileViewController else { return }
                profileVC.updateProfileImage(with: pickedImage)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? CollectionViewCell else { return CollectionViewCell() }
        
        if let url = URL(string: dataSource[indexPath.row].imageUrl) {
            model.fetchImage(with: url, completion: cell.configure)
        }
        return cell
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

// MARK: - ICollectionModelDelegate
extension CollectionViewController: ICollectionModelDelegate {
    func setup(dataSource: [CellDisplayModel]) {
        self.dataSource = dataSource
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func show(error message: String) {
        DispatchQueue.main.async {
            self.configureLogAlert(withTitle: "Network", withMessage: message)
        }
    }
}
