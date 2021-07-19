//
//  APIClientMock.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/19.
//

import struct Combine.AnyPublisher
@testable import AssignmentTimeline

final class APIClientMock: APIClientProtocol {
    var publisher: AnyPublisher<Any, Error>!
    func send<Request, Response>(request: Request) -> AnyPublisher<Response, Error> where Request : APIRequest, Response == Request.Response {
        return publisher
            .map { (value: Any) in
                return value as! Response
            }
            .eraseToAnyPublisher()
    }
    func send<Request, Response>(request: Request, retryAttemptCount: Int) -> AnyPublisher<Response, Error> where Request : APIRequest, Response == Request.Response {
        return publisher
            .map { (value: Any) in
                return value as! Response
            }
            .eraseToAnyPublisher()
    }
}
