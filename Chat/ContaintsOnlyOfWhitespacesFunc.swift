//
//  ContaintsOnlyOfWhitespacesFunc.swift
//  Chat
//
//  Created by Maria Myamlina on 30.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
// TODO: - Сделать как расширение String
func containtsOnlyOfWhitespaces(string: String) -> Bool {
    return string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}
