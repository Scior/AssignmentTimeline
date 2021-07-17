//
//  LoginState.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

struct LoginState: Equatable {
    var emailAddress: String
    var password: String
    var isValidEmailAddress: Bool
    var isValidPassword: Bool

    static let empty = LoginState(
        emailAddress: "",
        password: "",
        isValidEmailAddress: false,
        isValidPassword: false
    )
}
