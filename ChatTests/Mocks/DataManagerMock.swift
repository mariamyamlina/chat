//
//  DataManagerMock.swift
//  ChatTests
//
//  Created by Maria Myamlina on 02.12.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

@testable import Chat
import Foundation

final class DataManagerMock: IDataManager {
    var callsCount = 0
    var receivedNameInfo: Bool?
    var receivedBioInfo: Bool?
    var receivedImageInfo: Bool?
    var recievedInfo: Bool?
    var saveStub: (((Bool, Bool, Bool) -> Void) -> Void)?
    var loadStub: ((() -> Void) -> Void)?

    func save(nameDidChange: Bool,
              bioDidChange: Bool,
              imageDidChange: Bool,
              completion: @escaping (Bool, Bool, Bool) -> Void) {
        callsCount += 1
        (receivedNameInfo, receivedBioInfo, receivedImageInfo) = (nameDidChange, bioDidChange, imageDidChange)
        saveStub?(completion)
    }
    
    func load(mustReadBio: Bool,
              completion: @escaping () -> Void) {
        callsCount += 1
        recievedInfo = mustReadBio
        loadStub?(completion)
    }
}
