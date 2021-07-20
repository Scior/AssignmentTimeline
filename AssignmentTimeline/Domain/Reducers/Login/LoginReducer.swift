//
//  LoginReducer.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import ComposableArchitecture

extension SharedReducers {
    static let login = Reducer<LoginState, LoginAction, LoginEnvironment> { state, action, environment in
        switch action {
        case let .emailAddressChanged(address):
            switch environment.emailAddressValidator.validate(value: address) {
            case let .success(address):
                state.emailAddress = address
                state.isValidEmailAddress = true
            case .failure:
                state.emailAddress = address
                state.isValidEmailAddress = false
            }

            return .none
        case let .passwordChanged(password):
            switch environment.loginPasswordValidator.validate(value: password) {
            case let .success(password):
                state.password = password
                state.isValidPassword = true
            case .failure:
                state.password = password
                state.isValidPassword = false
            }

            return .none
        case .loginButtonTapped:
            let request = LoginRequest(requestBody: .init(mailAddress: state.emailAddress, password: state.password))

            return environment.loginRepository
                .login(request: request)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(LoginAction.loginResponse)
        case let .loginResponse(.success(response)):
            state.alertState.errorType = nil
            environment.accessTokenRepository.save(token: response.accessToken)

            return .none
        case let .loginResponse(.failure(error)):
            switch error {
            case .unauthorized:
                // 401の時だけパスワードを消しておく
                state.password = ""
                state.isValidPassword = false
                state.alertState = .init(errorType: .incorrectInputs)
            case .others:
                state.alertState = .init(errorType: .others)
            }

            return .none
        case .alert:
            return .none
        }
    }
}
