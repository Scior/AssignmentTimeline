//
//  LoginAction.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

enum LoginAction {
    case emailAddressChanged(String)
    case passwordChanged(String)
    case loginButtonTapped
    case loginResponse(Result<LoginResponse, Error>)
}
