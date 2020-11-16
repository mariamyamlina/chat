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
}
