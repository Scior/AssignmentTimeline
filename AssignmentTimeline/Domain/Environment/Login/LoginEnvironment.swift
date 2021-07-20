//
//  LoginEnvironment.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import Foundation
import typealias ComposableArchitecture.AnySchedulerOf

struct LoginEnvironment {
    let emailAddressValidator: EmailAddressValidatorProtocol
    let loginPasswordValidator: LoginPasswordValidatorProtocol
    let loginRepository: LoginRepositoryProtocol
    let accessTokenRepository: AccessTokenRepositoryProtocol
    let mainQueue: AnySchedulerOf<DispatchQueue>
}
