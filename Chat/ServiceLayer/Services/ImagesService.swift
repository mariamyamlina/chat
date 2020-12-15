//
//  ImagesService.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol IImagesService {
    func loadUrls(completionHandler: @escaping (DataModel?, NetworkError?) -> Void)
    func loadImage(with url: URL, completionHandler: @escaping (UIImage?, NetworkError?) -> Void)
    func cancelLoadImage(with url: URL)
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
    func loadUrls(completionHandler: @escaping (DataModel?, NetworkError?) -> Void) {
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
        requestSender.load(imageWithURL: url) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let data):
                completionHandler(UIImage(data: data), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func cancelLoadImage(with url: URL) {
        requestSender.cancel(loadingWithURL: url)
    }
}
