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
        // Arrange
        let app = XCUIApplication()
        app.launch()

        // Act
        let barButton = app.navigationBars.buttons["barButtonItem"]
        _ = barButton.waitForExistence(timeout: 3.0)
        barButton.tap()
        let textFields = app.textFields
        let textViews = app.textViews
        let nameTextView = app.textViews["nameTextView"].firstMatch
        let bioTextView = app.textViews["bioTextView"].firstMatch
        _ = nameTextView.waitForExistence(timeout: 3.0)
        _ = bioTextView.waitForExistence(timeout: 3.0)
        
        // Assert
        XCTAssertTrue(nameTextView.exists && bioTextView.exists)
        XCTAssertEqual(textViews.count + textFields.count, 2)
    }
}
