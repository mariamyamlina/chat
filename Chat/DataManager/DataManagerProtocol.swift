//
//  DataManagerProtocol.swift
//  Chat
//
//  Created by Maria Myamlina on 14.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol DataManagerProtocol: class {
    func saveToFile(completion: @escaping (Result) -> Void)
    func loadFromFile(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
}
