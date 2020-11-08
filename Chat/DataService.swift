//
//  DataService.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol DataServiceProtocol: class {
    func saveToFile(completion: @escaping (Bool) -> Void)
    func loadFromFile(mustReadName: Bool, mustReadBio: Bool, mustReadImage: Bool, completion: @escaping (Bool, Bool, Bool) -> Void)
}

class DataService {
    static var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    static let nameFile = "ProfileName.txt"
    static let bioFile = "ProfileBio.txt"
    static let imageFile = "ProfileImage.jpeg"
    
    static var nameFileURL: URL = DataService.urlDir?.appendingPathComponent(DataService.nameFile) ?? URL(fileURLWithPath: "")
    static var bioFileURL: URL = DataService.urlDir?.appendingPathComponent(DataService.bioFile) ?? URL(fileURLWithPath: "")
    static var imageFileURL: URL = DataService.urlDir?.appendingPathComponent(DataService.imageFile) ?? URL(fileURLWithPath: "")
}
