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

// MARK: - Requests
class YellowFlowersRequest: Request {
    override var command: String { return "&q=yellow+flowers&image_type=photo&pretty=true&per_page=100" }
}

class GreenNatureRequest: Request {
    override var command: String { return "&q=green+nature&image_type=photo&pretty=true&per_page=100" }
}

class BlueTravelRequest: Request {
    override var command: String { return "&q=blue+travel&image_type=photo&pretty=true&per_page=100" }
}

class PinkFasionRequest: Request {
    override var command: String { return "&q=pink+fashion&image_type=photo&pretty=true&per_page=100" }
}

class OrangeFoodRequest: Request {
    override var command: String { return "&q=orange+food&image_type=photo&pretty=true&per_page=100" }
}

class GrayBuildingsRequest: Request {
    override var command: String { return "&q=gray+buildings&image_type=photo&pretty=true&per_page=100" }
}

class RedFeelingsRequest: Request {
    override var command: String { return "&q=red+feelings&image_type=photo&pretty=true&per_page=100" }
}

class BlackPlacesRequest: Request {
    override var command: String { return "&q=black+places&image_type=photo&pretty=true&per_page=100" }
}

class BrownMusicRequest: Request {
    override var command: String { return "&q=brown+music&image_type=photo&pretty=true&per_page=100" }
}

class WhiteComputerRequest: Request {
    override var command: String { return "&q=white+computer&image_type=photo&pretty=true&per_page=100" }
}
