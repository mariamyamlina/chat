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

        let barButton = app.navigationBars.buttons["barButtonItem"]
        _ = barButton.waitForExistence(timeout: 3.0)
        barButton.tap()
        let textView = app.textViews["profileTextView"].firstMatch
        _ = textView.waitForExistence(timeout: 3.0)
        let textViews = app.textViews
        XCTAssertEqual(textViews.count, 2)
    }
}
