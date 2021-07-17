//
//  APIClientTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/16.
//

import Combine
import Foundation
import XCTest
@testable import AssignmentTimeline

final class APIClientTests: XCTestCase {
    var client: APIClient!
    var urlSession: URLSessionMock!

    override func setUp() {
        urlSession = URLSessionMock()
        client = APIClient(dependency: .init(jsonDecoder: APIClient.defaultJSONDecoder, urlSession: urlSession))
    }

    // MARK: - Test cases

    func testSendWith200StatusReturningCorrectResponse() throws {
        urlSession.response = HTTPURLResponse(url: Const.dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let response = TestResponse(text: "hoge")
        urlSession.data = try XCTUnwrap(response.toJSONData())

        waitForPublishing(response, publisher: client.send(request: TestRequest()))
    }

    func testSendWith500StatusReturningNetworkErrorFailed() throws {
        let statusCode = 500
        urlSession.response = HTTPURLResponse(url: Const.dummyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let data = try XCTUnwrap(TestResponse(text: "hoge").toJSONData())
        urlSession.data = data

        waitForPublishingError(publisher: client.send(request: TestRequest())) { error in
            if let error = error as? APIClient.NetworkError,
               case let .failed(code, _) = error {
                return code == statusCode
            }

            return false
        }
    }

    func testSendWithInvalidRequestReturningNetworkErrorInvalidRequest() throws {
        urlSession.response = HTTPURLResponse(url: Const.dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let response = TestResponse(text: "hoge")
        urlSession.data = try XCTUnwrap(response.toJSONData())

        waitForPublishingError(publisher: client.send(request: InvalidRequest())) { error in
            if let error = error as? APIClient.NetworkError,
               case .invalidRequest = error {
                return true
            }

            return false
        }
    }

    func testSendWithUndecodableResponseReturningDecodingError() throws {
        urlSession.response = HTTPURLResponse(url: Const.dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let response = TestResponse2(address: "hoge")
        urlSession.data = try XCTUnwrap(response.toJSONData())

        waitForPublishingError(publisher: client.send(request: TestRequest())) { error in
            return error is DecodingError
        }
    }
}

// MARK: - Helper classes

extension APIClientTests {
    final class URLSessionMock: URLSessionProtocol {
        var response: URLResponse!
        var data = Data()
        func requestPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
            return Just((data: data, response: response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
    }
    struct TestRequest: APIRequest {
        typealias Response = TestResponse
        let url = Const.dummyURL.absoluteString
        let method: HTTPMethod = .get
    }
    struct InvalidRequest: APIRequest {
        typealias Response = TestResponse
        let url = "//::::/:/:/"
        let method: HTTPMethod = .get
    }
    struct TestResponse: Codable, Equatable {
        let text: String
    }
    struct TestResponse2: Codable, Equatable {
        let address: String
    }
    enum Const {
        static let dummyURL: URL = .init(string: "https://hogehoge.com/")!
    }
}
