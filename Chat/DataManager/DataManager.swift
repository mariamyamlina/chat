//
//  DataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol DataManagerDelegate {
    func writeToFile(nameText: String?, bioText: String?, image: UIImage?, completion: @escaping (Bool) -> Void)
    func readFromFile(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool)
}

