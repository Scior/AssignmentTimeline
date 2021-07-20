//
//  TimelineEnvironment.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import Foundation
import typealias ComposableArchitecture.AnySchedulerOf

struct TimelineEnvironment {
    let repository: TimelineRepositoryProtocol
    let mainQueue: AnySchedulerOf<DispatchQueue>
}
