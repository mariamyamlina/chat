//
//  RequestsFactory.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

struct RequestsFactory {
    static func requestConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: RequestsFactory.generateRequest(), parser: Parser())
    }
    
    // MARK: - Generator
    static func generateRequest() -> Request {
        let array = [YellowFlowersRequest(), GreenNatureRequest(),
                     BlueTravelRequest(), PinkFashionRequest(),
                     OrangeFoodRequest(), GrayBuildingsRequest(),
                     RedFeelingsRequest(), BlackPlacesRequest(),
                     BrownMusicRequest(), WhiteComputerRequest()]
        if let request = array.randomElement() {
            return request
        } else {
            return YellowFlowersRequest()
        }
    }
}
