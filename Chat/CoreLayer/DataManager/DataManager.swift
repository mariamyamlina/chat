//
//  DataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol DataManagerProtocol: class {
    func save(completion: @escaping (Bool) -> Void)
    func load(mustReadBio: Bool, completion: @escaping () -> Void)
}
