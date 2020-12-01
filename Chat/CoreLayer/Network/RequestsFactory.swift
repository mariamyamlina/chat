//
//  RequestsFactory.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

struct RequestsFactory {
    static func yellowFlowersConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: YellowFlowersRequest(), parser: Parser())
    }
    
    static func greenNatureConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: GreenNatureRequest(), parser: Parser())
    }
    
    static func blueTravelConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: BlueTravelRequest(), parser: Parser())
    }
    
    static func pinkFashionConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: PinkFasionRequest(), parser: Parser())
    }
    
    static func orangeFoodConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: OrangeFoodRequest(), parser: Parser())
    }
    
    static func grayBuildingsConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: GrayBuildingsRequest(), parser: Parser())
    }
    
    static func redFeelingsConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: RedFeelingsRequest(), parser: Parser())
    }
    
    static func blackPlacesConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: BlackPlacesRequest(), parser: Parser())
    }
    
    static func brownMusicConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: BrownMusicRequest(), parser: Parser())
    }
    
    static func whiteComputerConfig() -> RequestConfig<Parser> {
        return RequestConfig<Parser>(request: WhiteComputerRequest(), parser: Parser())
    }
}
