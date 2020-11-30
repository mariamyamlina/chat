//
//  ChatTests.swift
//  ChatTests
//
//  Created by Maria Myamlina on 30.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

@testable import Chat
import XCTest

class ChatTests: XCTestCase {
    func testLoadingUrls() throws {
        // Arrange
        let url = "https://splashbase.s3.amazonaws.com/unsplash/regular/tumblr_n0hpthN8VH1st5lhmo1_1280.jpg"
        let hit = Chat.DataModel.Hit(webformatURL: url)
        let count = 150
        let model = DataModel(hits: Array(repeating: hit, count: count))
        let requestSenderMock = RequestSenderMock()
        requestSenderMock.sendStub = { completion in
            completion(.success(model))
        }
        
        // Act
        let imagesService = ImagesService(requestSender: requestSenderMock)
        imagesService.loadUrls { _, _ in }
//        func loadImage(with url: URL, completionHandler: @escaping (UIImage?, NetworkError?) -> Void)
//        func cancelLoadImage(with url: URL)
        
        // Assert
        XCTAssertEqual(requestSenderMock.callsCount, 1)
        XCTAssertEqual(requestSenderMock.receivedURLs.count, count)
        XCTAssertEqual(requestSenderMock.receivedURLs, [url])
    }
}
