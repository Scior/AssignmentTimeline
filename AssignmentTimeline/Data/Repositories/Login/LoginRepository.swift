//
//  LoginRepository.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import struct Combine.AnyPublisher
import Foundation

protocol LoginRepositoryProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginRequest.Response, LoginRepository.LoginError>
}

struct LoginRepository: LoginRepositoryProtocol {
    struct Dependency {
        let client: APIClientProtocol
    }
    enum LoginError: LocalizedError, Equatable {
        case unauthorized
        case others

        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Incorrect email address or password"
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

    func login(request: LoginRequest) -> AnyPublisher<LoginRequest.Response, LoginError> {
        return dependency.client.send(request: request, retryAttemptCount: 1)
            .mapError { error -> LoginError in
                switch error {
                case APIClient.NetworkError.failed(401, _):
                    return .unauthorized
                default:
                    return .others
                }
            }
            .eraseToAnyPublisher()
    }
}
