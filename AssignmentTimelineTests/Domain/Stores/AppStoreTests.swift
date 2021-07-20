//
//  AppStoreTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/20.
//

import Combine
import ComposableArchitecture
import XCTest
@testable import AssignmentTimeline

final class AppStoreTests: XCTestCase {
    private var apiClientMock: APIClientMock!
    private var accessTokenRepositoryMock: AccessTokenRepositoryMock!
    private var testStore: TestStore<AppState, AppState, AppAction, AppAction, AppEnvironment>!

    override func setUp() {
        apiClientMock = .init()
        accessTokenRepositoryMock = .init()
        resetTestStore(initialState: .login(.empty))
    }

    private func resetTestStore(initialState: AppState) {
        testStore = TestStore(
            initialState: initialState,
            reducer: SharedReducers.app,
            environment: .init(
                apiClient: apiClientMock,
                accessTokenRepository: accessTokenRepositoryMock,
                mainQueue: .immediate
            )
        )
    }

    // MARK: - Test cases

    func testLoginFailure() {
        testStore.send(.login(.loginResponse(.failure(.others)))) {
            var state = LoginState.empty
            state.alertState.errorType = .others
            $0 = .login(state)
        }
    }

    func testLoginSuccess() {
        testStore.send(.login(.loginResponse(.success(.init(accessToken: ""))))) {
            $0 = .timeline(.empty)
        }
    }
}
