//
//  ThemeStorageMock.swift
//  ChatTests
//
//  Created by Maria Myamlina on 02.12.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

@testable import Chat
import Foundation

final class ThemeStorageMock: IThemeStorage {
    var callsCount = 0
    var receivedRawValue: Int?
    var themesStub: (((Int) -> Void) -> Void)?

    func save(themeRawValue: Int, completion: (Int) -> Void) {
        callsCount += 1
        self.receivedRawValue = themeRawValue
        themesStub?(completion)
    }
    
    func load() -> Int {
        callsCount += 1
        return Theme.classic.rawValue
    }
}
