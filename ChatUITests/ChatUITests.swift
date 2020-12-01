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

    func testEntryFields() throws {
        let app = XCUIApplication()
        app.launch()

        let barButton = app.navigationBars.buttons["barButtonItem"]
        _ = barButton.waitForExistence(timeout: 3.0)
        barButton.tap()
        let textView = app.textViews["profileTextView"].firstMatch
        let textViews = app.textViews
        let textFields = app.textFields
        _ = textView.waitForExistence(timeout: 3.0)
        XCTAssertEqual(textViews.count + textFields.count, 2)
    }
}