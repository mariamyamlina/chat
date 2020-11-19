//
//  RequestSender.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: IParser
}

enum NetworkError: Error {
    case badURL
    case badData
    case badTask
    
    var message: String {
        switch self {
        case .badURL: return "Error trying to create URL request: URL string can't be parsed to URL"
        case .badData: return "Error trying to convert data to JSON: received data can't be parsed"
        case .badTask: return "Error trying to handle DataTask"
        }
    }
}

protocol IRequestSender {
    func send(requestConfig: RequestConfig<Parser>,
              completionHandler: @escaping (Result<DataModel, NetworkError>) -> Void)
    func getImage(with url: URL,
                  completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void)
}

class RequestSender: IRequestSender {
    let session = URLSession.shared
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<DataModel, NetworkError>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(.badURL))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, _, error: Error?) in
            guard error == nil else {
                completionHandler(.failure(.badTask))
                return
            }
            
            guard let data = data,
                let parsedModel = config.parser.parse(data: data) else {
                    completionHandler(.failure(.badData))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
    
    func getImage(with url: URL,
                  completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(.failure(.badTask))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.badData))
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(Result.success(UIImage(data: data)))
            }
        }
        task.resume()
    }
}
