//
//  URLSessionProtocol.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/16.
//

import Combine
import Foundation

protocol URLSessionProtocol {
    func requestPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>
}

extension URLSession: URLSessionProtocol {
    func requestPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
