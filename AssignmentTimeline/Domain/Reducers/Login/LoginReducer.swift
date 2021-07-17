//
//  LoginReducer.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import struct ComposableArchitecture.Reducer

extension SharedReducers {
    static let login = Reducer<LoginState, LoginAction, LoginEnvironment> { _, _, _ in
        return .none
    }
}
