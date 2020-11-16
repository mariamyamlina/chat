//
//  RequestSender.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum NetworkError: Error {
    case badURL
    case badData
    case badTask
}

protocol IRequestSender {
    func send(requestConfig: RequestConfig<Parser>,
              completionHandler: @escaping (Result<DataModel, NetworkError>) -> Void)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<DataModel, NetworkError>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(.badURL))
//                Result<Int, NetworkError>.error("url string can't be parsed to URL"))
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
//                        Result.error("received data can't be parsed"))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
