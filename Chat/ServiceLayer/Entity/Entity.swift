//
//  EntityProtocol.swift
//  Chat
//
//  Created by Maria Myamlina on 01.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

enum EntityType {
    case channel
    case message
}

protocol EntityProtocol {
    var identifier: String { get }
}
