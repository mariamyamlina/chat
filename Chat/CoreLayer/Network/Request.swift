//
//  Request.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class Request: IRequest {
    fileprivate var command: String {
        assertionFailure("Should use a subclass of Request")
        return ""
    }
    private var baseUrl: String = "https://pixabay.com/api/?key="
    private var apiKey = "19123229-ae49243578cecb1abfcac9d42"
    
    // MARK: - IRequest
    var urlRequest: URLRequest? {
        let urlString: String = baseUrl + apiKey + command
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
}

class YellowFlowersRequest: Request {
    override var command: String { return "&q=yellow+flowers&image_type=photo&pretty=true&per_page=100" }
}

class GreenNatureRequest: Request {
    override var command: String { return "&q=green+nature&image_type=photo&pretty=true&per_page=100" }
}

class BlueTravelRequest: Request {
    override var command: String { return "&q=blue+travel&image_type=photo&pretty=true&per_page=100" }
}
