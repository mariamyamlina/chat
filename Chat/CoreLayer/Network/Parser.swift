//
//  Parser.swift
//  Chat
//
//  Created by Maria Myamlina on 15.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

struct DataModel: Decodable {
    let hits: [Hit]
    
    struct Hit: Decodable {
        let webformatURL: String
    }
    
    enum RootKey: String, CodingKey {
        case hits
    }
}

protocol IParser {
    func parse(data: Data) -> DataModel?
}

class Parser: IParser {
    func parse(data: Data) -> DataModel? {
        do {
            let dataModel = try JSONDecoder().decode(DataModel.self, from: data)
            
            return dataModel
            
        } catch {
            print("Error trying to convert data to JSON")
            return nil
        }
    }
}
