//
//  RequestSenderMock.swift
//  ChatTests
//
//  Created by Maria Myamlina on 30.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

@testable import Chat
import Foundation

final class RequestSenderMock: IRequestSender {
    var callsCount = 0
    var receivedURLs: [String?] = []
    var sendStub: (((Result<DataModel, NetworkError>) -> Void) -> Void)?
    var loadStub: (((Result<Data, NetworkError>) -> Void) -> Void)?

    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<DataModel, NetworkError>) -> Void) {
        callsCount += 1
        receivedURLs.append(config.request.urlRequest?.url?.absoluteString)
        guard let stub = sendStub else { return }
        stub(completionHandler)
    }

    func load(imageWithURL url: URL,
              completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        callsCount += 1
        receivedURLs.append(url.absoluteString)
        guard let stub = loadStub else { return }
        stub(completionHandler)
    }

    func cancel(loadingWithURL url: URL) {
        receivedURLs.append(url.absoluteString)
    }
}
