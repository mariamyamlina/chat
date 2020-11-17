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
        let randNum = Int(arc4random_uniform(9))
        let requestConfig: RequestConfig<Parser>
        switch randNum {
        case 1:
            requestConfig = RequestsFactory.greenNatureConfig()
        case 2:
            requestConfig = RequestsFactory.blueTravelConfig()
        case 3:
            requestConfig = RequestsFactory.pinkFashionConfig()
        case 4:
            requestConfig = RequestsFactory.orangeFoodConfig()
        case 5:
            requestConfig = RequestsFactory.grayBuildingsConfig()
        case 6:
            requestConfig = RequestsFactory.redFeelingsConfig()
        case 7:
            requestConfig = RequestsFactory.blackPlacesConfig()
        case 8:
            requestConfig = RequestsFactory.brownMusicConfig()
        case 9:
            requestConfig = RequestsFactory.whiteComputerConfig()
        default:
            requestConfig = RequestsFactory.yellowFlowersConfig()
        }
        return requestConfig
    }
}
