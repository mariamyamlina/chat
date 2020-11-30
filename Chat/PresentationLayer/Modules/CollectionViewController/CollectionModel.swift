//
//  CollectionModel.swift
//  Chat
//
//  Created by Maria Myamlina on 13.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

// MARK: - CollectionCellModel
protocol ICollectionCellModel: class {
    func fetchImage(completion: @escaping (UIImage?) -> Void)
    func cancelFetch()
}

class CollectionCellModel {
    // MARK: - Dependencies
    let imageUrl: URL?
    let imagesService: IImagesService

    // MARK: - Init / deinit
    init(imageUrl: URL?, imagesService: IImagesService) {
        self.imageUrl = imageUrl
        self.imagesService = imagesService
    }
}

// MARK: - ICollectionCellModel
extension CollectionCellModel: ICollectionCellModel {
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = imageUrl else { return }
        imagesService.loadImage(with: url) { (image: UIImage?, _) in
            completion(image)
        }
    }
    
    func cancelFetch() {
        guard let url = imageUrl else { return }
        imagesService.cancelLoadImage(with: url)
    }
}

// MARK: - CollectionModel
protocol ICollectionModel: class {
    var delegate: ICollectionModelDelegate? { get set }
    var currentTheme: Theme { get }
    func fetchUrls()
}

protocol ICollectionModelDelegate: class {
    func setup(dataSource: [CollectionCellModel])
    func show(error message: String)
}

class CollectionModel {
    // MARK: - Dependencies
    weak var delegate: ICollectionModelDelegate?
    var settingsService: ISettingsService
    var imagesService: IImagesService
    
    // MARK: - Init / deinir
    init(settingsService: ISettingsService, imagesService: IImagesService) {
        self.settingsService = settingsService
        self.imagesService = imagesService
    }
}

// MARK: - ICollectionModel
extension CollectionModel: ICollectionModel {
    var currentTheme: Theme { return settingsService.currentTheme }
    
    func fetchUrls() {
        imagesService.loadUrls { (images: DataModel?, error) in
            if let images = images {
                let cells = images.hits.map({ CollectionCellModel(imageUrl: URL(string: $0.webformatURL),
                                                                  imagesService: self.imagesService) })
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: error?.message ?? "")
            }
        }
    }
}
