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
    // MARK: - ImagesService
    func testLoadingUrls() throws {
        // Arrange
        let url = "https://splashbase.s3.amazonaws.com/unsplash/regular/tumblr_n0hpthN8VH1st5lhmo1_1280.jpg"
        let hit = Chat.DataModel.Hit(webformatURL: url)
        let model = DataModel(hits: Array(repeating: hit, count: 150))
        let requestSenderMock = RequestSenderMock()
        requestSenderMock.sendStub = { completion in
            completion(.success(model))
        }
        
        // Act
        let imagesService = ImagesService(requestSender: requestSenderMock)
        imagesService.loadUrls { _, _ in }
        let str = (requestSenderMock.receivedURLs.first ?? "") ?? ""
        let substr = str.prefix(20)
        
        // Assert
        XCTAssertEqual(requestSenderMock.callsCount, 1)
        XCTAssertEqual(requestSenderMock.receivedURLs.count, 1)
        XCTAssertEqual(substr, "https://pixabay.com/")
    }
    
    func testLoadingPhoto() throws {
        // Arrange
        let imageUrl = URL(string: "https://splashbase.s3.amazonaws.com/unsplash/regular/tumblr_msue6ubSHn1st5lhmo1_1280.jpg")
        guard let url = imageUrl else { return }
        let data = Data()
        let requestSenderMock = RequestSenderMock()
        requestSenderMock.loadStub = { completion in
            completion(.success(data))
        }
                
        // Act
        let imagesService = ImagesService(requestSender: requestSenderMock)
        imagesService.loadImage(with: url) { _, _ in }
                
        // Assert
        XCTAssertEqual(requestSenderMock.callsCount, 1)
        XCTAssertEqual(requestSenderMock.receivedURLs, [imageUrl?.absoluteString])
    }
    
    func testCanceling() throws {
        // Arrange
        let imageUrl = URL(string: "https://splashbase.s3.amazonaws.com/unsplash/regular/tumblr_mo2x3aAnRH1st5lhmo1_1280.jpg")
        guard let url = imageUrl else { return }
        let requestSenderMock = RequestSenderMock()
                    
        // Act
        let imagesService = ImagesService(requestSender: requestSenderMock)
        imagesService.cancelLoadImage(with: url)
                    
        // Assert
        XCTAssertEqual(requestSenderMock.callsCount, 1)
        XCTAssertEqual(requestSenderMock.receivedURLs, [imageUrl?.absoluteString])
    }
    
    // MARK: - ThemesService
    func testSavingTheme() throws {
        // Arrange
        let themesRawValue = 0
        let theme = Theme(rawValue: 0) ?? .classic
        let themeStorageMock = ThemeStorageMock()
        themeStorageMock.themesStub = { completion in
            completion(themesRawValue)
        }
        
        // Act
        let themesService = ThemesService(themeStorage: themeStorageMock)
        themesService.applyTheme(for: theme) { _ in }
        
        // Assert
        XCTAssertEqual(themeStorageMock.callsCount, 1)
        XCTAssertEqual(themeStorageMock.receivedRawValue, themesRawValue)
    }
    
    // MARK: - DataService
    func testSavingData() throws {
        // Arrange
        let indicator = true
        let dataManagerMock = DataManagerMock()
        dataManagerMock.saveStub = { completion in
            completion(indicator, indicator, indicator)
        }
        
        // Act
        let dataService = DataService(gcdDataManager: dataManagerMock,
                                      operationDataManager: dataManagerMock)
        dataService.save(dataManager: dataService.gcdDataManager,
                         nameDidChange: indicator,
                         bioDidChange: indicator,
                         imageDidChange: indicator) { _, _, _  in }
        
        // Assert
        XCTAssertEqual(dataManagerMock.callsCount, 1)
        XCTAssertTrue(dataManagerMock.receivedNameInfo == indicator)
        XCTAssertTrue(dataManagerMock.receivedBioInfo == indicator)
        XCTAssertTrue(dataManagerMock.receivedImageInfo == indicator)
    }
    
    func testLoadingData() throws {
        // Arrange
        let indicator = false
        let dataManagerMock = DataManagerMock()
        dataManagerMock.loadStub = { completion in
            completion()
        }
        
        // Act
        let dataService = DataService(gcdDataManager: dataManagerMock,
                                      operationDataManager: dataManagerMock)
        dataService.load(dataManager: dataService.gcdDataManager, mustReadBio: indicator) { }
        
        // Assert
        XCTAssertEqual(dataManagerMock.callsCount, 1)
        XCTAssertTrue(dataManagerMock.recievedInfo == indicator)
    }
}
