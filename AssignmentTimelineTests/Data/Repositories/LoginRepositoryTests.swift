//
//  LoginRepositoryTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/19.
//

import Combine
import XCTest
@testable import AssignmentTimeline

final class LoginRepositoryTests: XCTestCase {
    var apiClientMock: APIClientMock!
    var loginRepository: LoginRepository!

    override func setUp() {
        apiClientMock = APIClientMock()
        loginRepository = LoginRepository(dependency: .init(client: apiClientMock))
    }

    // MARK: - Test cases

    func testLoginWithResponse() {
        let response = LoginResponse(accessToken: "hoge")
        apiClientMock.publisher = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        waitForPublishing(
            response,
            publisher: loginRepository.login(request: .init(requestBody: .init(mailAddress: "", password: "")))
        )
    }

    func testLoginWithError() {
        let responseStatusCode = 401
        apiClientMock.publisher = Fail<Any, Error>(error: APIClient.NetworkError.failed(statusCode: responseStatusCode, data: .init()))
            .eraseToAnyPublisher()

        waitForPublishingError(publisher: loginRepository.login(
            request: .init(requestBody: .init(mailAddress: "", password: ""))
        )) { error in
            if case let APIClient.NetworkError.failed(statusCode, _) = error {
                return statusCode == responseStatusCode
            } else {
                return false
            }
        }
    }
}
