//
//  DataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 09.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol IDataManager: class {
    func save(nameDidChange: Bool,
              bioDidChange: Bool,
              imageDidChange: Bool,
              completion: @escaping (Bool, Bool, Bool) -> Void)
    func load(mustReadBio: Bool,
              completion: @escaping () -> Void)
}
