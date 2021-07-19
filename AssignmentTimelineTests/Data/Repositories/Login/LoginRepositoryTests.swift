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
        apiClientMock.publisher = justAnyError(response)

        waitForPublishing(
            response,
            publisher: loginRepository.login(request: .init(requestBody: .init(mailAddress: "", password: "")))
        )
    }

    func testLoginWithUnauthorizedError() {
        let responseStatusCode = 401
        apiClientMock.publisher = failAnyError(APIClient.NetworkError.failed(statusCode: responseStatusCode, data: .init()))

        waitForPublishingError(publisher: loginRepository.login(
            request: .init(requestBody: .init(mailAddress: "", password: ""))
        )) { error in
            return error == .unauthorized
        }
    }

    func testLoginWithOtherError() {
        let responseStatusCode = 500
        apiClientMock.publisher = failAnyError(APIClient.NetworkError.failed(statusCode: responseStatusCode, data: .init()))

        waitForPublishingError(publisher: loginRepository.login(
            request: .init(requestBody: .init(mailAddress: "", password: ""))
        )) { error in
            return error == .others
        }
    }
}
