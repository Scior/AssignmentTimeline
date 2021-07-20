//
//  TimelineEnvironment.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import Foundation
import typealias ComposableArchitecture.AnySchedulerOf

struct TimelineEnvironment {
    let timelineRepository: TimelineRepositoryProtocol
    let accessTokenRepository: AccessTokenRepositoryProtocol
    let mainQueue: AnySchedulerOf<DispatchQueue>
}
