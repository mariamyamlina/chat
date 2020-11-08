//
//  ProfileModel.swift
//  Chat
//
//  Created by Maria Myamlina on 08.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol ProfileModelProtocol: class {
    var delegate: ProfileModelDelegate? { get set }
}

protocol ProfileModelDelegate: class {
//    func setup(dataSource: [???])
//    func show(error message: String)
}

class ProfileModel: ProfileModelProtocol {
    weak var delegate: ProfileModelDelegate?
    
    let cardsService: CardsServiceProtocol
    let tracksService: TracksServiceProtocol
    
    init(cardsService: CardsServiceProtocol, tracksService: TracksServiceProtocol) {
        self.cardsService = cardsService
        self.tracksService = tracksService
    }
}
