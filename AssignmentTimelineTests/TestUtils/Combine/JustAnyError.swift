//
//  JustAnyError.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/19.
//

import Combine

func justAnyError<T>(_ value: T) -> AnyPublisher<Any, Error> {
    return Just(value)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}
