//
//  CollectionModel.swift
//  Chat
//
//  Created by Maria Myamlina on 13.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

// MARK: - CollectionCellModel
struct CollectionCellModel {
    let image: UIImage?
}

struct CellDisplayModel {
    let imageUrl: String
}

protocol ICollectionModel: class {
    var delegate: ICollectionModelDelegate? { get set }
    var currentTheme: Theme { get }
    func fetchImages()
    func fetchImage(with url: URL, completion: @escaping (CollectionCellModel, Theme) -> Void)
}

protocol ICollectionModelDelegate: class {
    func setup(dataSource: [CellDisplayModel])
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
    
    func fetchImages() {
        imagesService.loadImages { (images: DataModel?, error) in
            if let images = images {
                let cells = images.hits.map({ CellDisplayModel(imageUrl: $0.webformatURL) })
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: error?.message ?? "")
            }
        }
    }
    
    func fetchImage(with url: URL, completion: @escaping (CollectionCellModel, Theme) -> Void) {
        imagesService.loadImage(with: url) { (image: UIImage?, error) in
            if let image = image {
                completion(CollectionCellModel(image: image), self.settingsService.currentTheme)
            } else {
                self.delegate?.show(error: error?.message ?? "")
            }
        }
    }
}