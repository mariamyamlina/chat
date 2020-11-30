//
//  ChatUITests.swift
//  ChatUITests
//
//  Created by Maria Myamlina on 29.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import XCTest

class ChatUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let textFieldsCount = app.textViews.count
        XCTAssertTrue(textFieldsCount == 0)
    }
}
