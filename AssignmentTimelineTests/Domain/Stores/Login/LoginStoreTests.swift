//
//  LoginStoreTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/19.
//

import Combine
import ComposableArchitecture
import XCTest
@testable import AssignmentTimeline

final class LoginStoreTests: XCTestCase {
    private var emailAddressValidatorMock: EmailAddressValidatorMock!
    private var loginPasswordValidatorMock: LoginPasswordValidatorMock!
    private var loginRepositoryMock: LoginRepositoryMock!
    private var testStore: TestStore<LoginState, LoginState, LoginAction, LoginAction, LoginEnvironment>!

    override func setUp() {
        emailAddressValidatorMock = .init()
        loginPasswordValidatorMock = .init()
        loginRepositoryMock = .init()
        resetTestStore(initialState: .empty)
    }

    private func resetTestStore(initialState: LoginState) {
        testStore = TestStore(
            initialState: initialState,
            reducer: SharedReducers.login,
            environment: .init(
                emailAddressValidator: emailAddressValidatorMock,
                loginPasswordValidator: loginPasswordValidatorMock,
                repository: loginRepositoryMock,
                mainQueue: .immediate
            )
        )
    }

    // MARK: - Test cases

    func testInputEmailAddress() {
        emailAddressValidatorMock.validateReturnValue = .failure(.notPassed)
        testStore.send(.emailAddressChanged("hoge")) {
            $0.emailAddress = "hoge"
            $0.isValidEmailAddress = false
        }

        emailAddressValidatorMock.validateReturnValue = .success("hogefuga")
        testStore.send(.emailAddressChanged("fugafuga")) {
            $0.emailAddress = "hogefuga"
            $0.isValidEmailAddress = true
        }
    }

    func testInputPassword() {
        loginPasswordValidatorMock.validateReturnValue = .failure(.notPassed)
        testStore.send(.passwordChanged("aaa")) {
            $0.password = "aaa"
            $0.isValidPassword = false
        }

        loginPasswordValidatorMock.validateReturnValue = .success("ccc")
        testStore.send(.passwordChanged("bbb")) {
            $0.password = "ccc"
            $0.isValidPassword = true
        }
    }

    func testTapLoginButtonWithLoginFailure() {
        resetTestStore(initialState: .init(
            emailAddress: "aaa",
            password: "bbb",
            isValidEmailAddress: false,
            isValidPassword: true,
            alertState: .init()
        ))
        loginRepositoryMock.loginReturnValue = Fail(error: LoginRepository.LoginError.unauthorized)
            .eraseToAnyPublisher()
        testStore.send(.loginButtonTapped)
        testStore.receive(.loginResponse(.failure(.unauthorized))) {
            $0.emailAddress = "aaa"
            $0.password = ""
            $0.isValidEmailAddress = false
            $0.isValidPassword = false
            $0.alertState.errorType = .incorrectInputs
        }
    }

    func testTapLoginButtonWithLoginSuccess() {
        resetTestStore(initialState: .init(
            emailAddress: "aaa",
            password: "bbb",
            isValidEmailAddress: false,
            isValidPassword: true,
            alertState: .init()
        ))
        let response = LoginResponse(accessToken: "token")
        loginRepositoryMock.loginReturnValue = Just(response)
            .setFailureType(to: LoginRepository.LoginError.self)
            .eraseToAnyPublisher()
        testStore.send(.loginButtonTapped)
        testStore.receive(.loginResponse(.success(response))) {
            $0.emailAddress = "aaa"
            $0.password = "bbb"
            $0.isValidEmailAddress = false
            $0.isValidPassword = true
            $0.alertState.errorType = nil
        }
    }
}

private extension LoginStoreTests {
    final class EmailAddressValidatorMock: EmailAddressValidatorProtocol {
        var validateReturnValue: Result<String, ValidationError>!
        func validate(value: String) -> Result<String, ValidationError> {
            return validateReturnValue
        }
    }

    final class LoginPasswordValidatorMock: LoginPasswordValidatorProtocol {
        var validateReturnValue: Result<String, ValidationError>!
        func validate(value: String) -> Result<String, ValidationError> {
            return validateReturnValue
        }
    }

    final class LoginRepositoryMock: LoginRepositoryProtocol {
        var loginReturnValue: AnyPublisher<LoginRequest.Response, LoginRepository.LoginError>!
        func login(request: LoginRequest) -> AnyPublisher<LoginRequest.Response, LoginRepository.LoginError> {
            return loginReturnValue
        }
    }
}
