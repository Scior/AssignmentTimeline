//
//  LoginRepository.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import struct Combine.AnyPublisher

protocol LoginRepositoryProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginRequest.Response, Error>
}

struct LoginRepository: LoginRepositoryProtocol {

    struct Dependency {
        let client: APIClientProtocol
    }
    // MARK: - Properties

    private let dependency: Dependency

    // MARK: - Lifecycle

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Methods

    func login(request: LoginRequest) -> AnyPublisher<LoginRequest.Response, Error> {
        return dependency.client.send(request: request, retryAttemptCount: 1)
    }
}
