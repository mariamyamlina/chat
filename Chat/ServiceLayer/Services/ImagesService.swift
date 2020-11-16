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

class ImagesService: IImagesService {
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImages(completionHandler: @escaping (DataModel?, NetworkError?) -> Void) {
        let requestConfig = RequestsFactory.yellowFlowersConfig()
        loadApps(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    private func loadApps(requestConfig: RequestConfig<Parser>,
                          completionHandler: @escaping (DataModel?, NetworkError?) -> Void) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<DataModel, NetworkError>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
