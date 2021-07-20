//
//  AppEnvironment.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import Foundation
import typealias ComposableArchitecture.AnySchedulerOf

struct AppEnvironment {
    let apiClient: APIClientProtocol
    let accessTokenRepository: AccessTokenRepositoryProtocol
    let mainQueue: AnySchedulerOf<DispatchQueue>
}
