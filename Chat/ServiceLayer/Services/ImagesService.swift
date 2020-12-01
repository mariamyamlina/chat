//
//  ImagesService.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol IImagesService {
    func loadImages(completionHandler: @escaping (DataModel?, NetworkError?) -> Void)
    func loadImage(with url: URL, completionHandler: @escaping (UIImage?, NetworkError?) -> Void)
}

class ImagesService {
    // MARK: - Dependencies
    let requestSender: IRequestSender

    // MARK: - Init / Deinit
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
}

// MARK: - IImagesService
extension ImagesService: IImagesService {
    func loadImages(completionHandler: @escaping (DataModel?, NetworkError?) -> Void) {
        let requestConfig = RequestsFactory.requestConfig()
        requestSender.send(requestConfig: requestConfig) { (result: Result<DataModel, NetworkError>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImage(with url: URL, completionHandler: @escaping (UIImage?, NetworkError?) -> Void) {
        requestSender.getImage(with: url) { (result: Result<UIImage?, NetworkError>) in
            switch result {
            case .success(let image):
                completionHandler(image, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
