//
//  LoginAlertReducer.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/18.
//

import struct ComposableArchitecture.Reducer

extension SharedReducers {
    static let loginAlert = Reducer<LoginAlertState, LoginAlertAction, EmptyEnvironment> { state, action, _ in
        switch action {
        case let .errorType(errorType):
            state.errorType = errorType

            return .none
        }
    }
}
