//
//  TimelineRepository.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import struct Combine.AnyPublisher
import Foundation

protocol TimelineRepositoryProtocol {
    func getTimeline(request: TimelineRequest) -> AnyPublisher<TimelineRequest.Response, TimelineRepository.TimelineError>
}

struct TimelineRepository: TimelineRepositoryProtocol {
    struct Dependency {
        let client: APIClientProtocol
    }
    enum TimelineError: LocalizedError, Equatable {
        case unauthorized
        case notFound
        case others

        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Unauthorized"
            case .notFound:
                return "Articles are not found"
            case .others:
                return "Internal server error or caused by other technical reasons"
            }
        }
    }

    // MARK: - Properties

    private let dependency: Dependency

    // MARK: - Lifecycle

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Methods

    func getTimeline(request: TimelineRequest) -> AnyPublisher<TimelineRequest.Response, TimelineRepository.TimelineError> {
        return dependency.client.send(request: request, retryAttemptCount: 1)
            .mapError { error -> TimelineError in
                switch error {
                case APIClient.NetworkError.failed(401, _):
                    return .unauthorized
                case APIClient.NetworkError.failed(404, _):
                    return .notFound
                default:
                    return .others
                }
            }
            .eraseToAnyPublisher()
    }
}
