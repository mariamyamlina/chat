//
//  Model.swift
//  Chat
//
//  Created by Maria Myamlina on 01.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

enum ModelType {
    case channel
    case message
}

protocol IModel {
    var identifier: String { get }
}
