//
//  LoginReducer.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import struct ComposableArchitecture.Reducer

extension SharedReducers {
    static let login = Reducer<LoginState, LoginAction, LoginEnvironment> { state, action, environment in
        switch action {
        case let .didEmailAddressChange(address):
            switch environment.emailAddressValidator.validate(value: address) {
            case let .success(address):
                state.emailAddress = address
                state.isValidEmailAddress = true
            case .failure:
                state.emailAddress = address
                state.isValidEmailAddress = false
            }

            return .none
        case let .didPasswordChange(password):
            switch environment.loginPasswordValidator.validate(value: password) {
            case let .success(password):
                state.password = password
                state.isValidPassword = true
            case .failure:
                state.password = password
                state.isValidPassword = false
            }

            return .none
        }
    }
}
