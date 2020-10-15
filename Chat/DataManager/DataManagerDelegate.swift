//
//  DataManagerDelegate.swift
//  Chat
//
//  Created by Maria Myamlina on 14.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol DataManagerDelegate: class {
    func writeToFile(completion: @escaping (Bool) -> Void)
    func readFromFile(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
}
