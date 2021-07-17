//
//  LoginEnvironment.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

struct LoginEnvironment {
    let emailAddressValidator: EmailAddressValidatorProtocol
    let loginPasswordValidator: LoginPasswordValidatorProtocol
}
