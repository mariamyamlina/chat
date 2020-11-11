//
//  ConfigurableView.swift
//  Chat
//
//  Created by Maria Myamlina on 11.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel, theme: Theme)
}
