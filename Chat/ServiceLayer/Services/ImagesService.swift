//
//  ImagesService.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol IImagesService {
    func loadImages(completionHandler: @escaping (DataModel?, NetworkError?) -> Void)
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
        let requestConfig = generateRequestConfig()
        requestSender.send(requestConfig: requestConfig) { (result: Result<DataModel, NetworkError>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    // MARK: - Generator
    private func generateRequestConfig() -> RequestConfig<Parser> {
        let array = [RequestsFactory.yellowFlowersConfig(), RequestsFactory.greenNatureConfig(),
                     RequestsFactory.blueTravelConfig(), RequestsFactory.pinkFashionConfig(),
                     RequestsFactory.orangeFoodConfig(), RequestsFactory.grayBuildingsConfig(),
                     RequestsFactory.redFeelingsConfig(), RequestsFactory.blackPlacesConfig(),
                     RequestsFactory.brownMusicConfig(), RequestsFactory.whiteComputerConfig()]
        if let requestConfig = array.randomElement() {
            return requestConfig
        } else {
            return RequestsFactory.yellowFlowersConfig()
        }
    }
}
