//
//  FailAnyError.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/19.
//

import Combine

func failAnyError(_ error: Error) -> AnyPublisher<Any, Error> {
    return Fail<Any, Error>(error: error)
        .eraseToAnyPublisher()
}
