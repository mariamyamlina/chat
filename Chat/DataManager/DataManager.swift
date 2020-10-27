//
//  DataManager.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class DataManager {
    static var urlDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    static let nameFile = "ProfileName.txt"
    static let bioFile = "ProfileBio.txt"
    static let imageFile = "ProfileImage.jpeg"
    
    static var nameFileURL: URL = DataManager.urlDir?.appendingPathComponent(DataManager.nameFile) ?? URL(fileURLWithPath: "")
    static var bioFileURL: URL = DataManager.urlDir?.appendingPathComponent(DataManager.bioFile) ?? URL(fileURLWithPath: "")
    static var imageFileURL: URL = DataManager.urlDir?.appendingPathComponent(DataManager.imageFile) ?? URL(fileURLWithPath: "")
    
    static func returnDataManager<T: DataManagerProtocol>(of type: DataManagerType) -> T? {
        switch type {
        case .gcd:
            return GCDDataManager() as? T
        case .operation:
            return OperationDataManager() as? T
        }
    }
}
