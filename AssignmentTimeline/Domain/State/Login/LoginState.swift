//
//  LoginState.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

struct LoginState: Equatable {
    let emailAddress: String
    let password: String

    static let empty = LoginState(emailAddress: "", password: "")
}
