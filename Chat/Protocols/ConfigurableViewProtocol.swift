//
//  ConfigurableViewProtocol.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
