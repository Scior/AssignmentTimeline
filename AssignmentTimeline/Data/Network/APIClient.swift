//
//  APIClient.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/16.
//

import os.log
import Combine
import Foundation

protocol APIClientProtocol {
    func send<Request, Response>(request: Request) -> AnyPublisher<Response, Error>
    where Request: APIRequest, Request.Response == Response
    func send<Request, Response>(request: Request, retryAttemptCount: Int) -> AnyPublisher<Response, Error>
    where Request: APIRequest, Request.Response == Response
}

struct APIClient: APIClientProtocol {
    static let shared = APIClient(dependency: .init(jsonDecoder: defaultJSONDecoder, urlSession: URLSession.shared))

    // MARK: - Structs

    struct Dependency {
        let jsonDecoder: JSONDecoder
        let urlSession: URLSessionProtocol
    }
    enum NetworkError: LocalizedError {
        case invalidRequest
        case invalidResponse(data: Data)
        case failed(statusCode: Int, data: Data)

        var errorDescription: String? {
            switch self {
            case .invalidRequest:
                return "An invalid request is given"
            case let .invalidResponse(data):
                return "Failed to convert a response to HTTPURLResponse: \(data)"
            case let .failed(statusCode, data):
                return "A server returned \(statusCode): \(data)"
            }
        }
    }

    // MARK: - Properties

    private let dependency: Dependency

    static let defaultJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: - Lifecycle

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Methods

    /// `URLSession`を使ってリクエストを送り, `Response`にデコードする.
    /// - Parameters:
    ///   - request: リクエスト
    ///   - retryAttemptCount: リトライの試行回数.
    /// - Returns: 成功した場合`Response`が流れる. 失敗した場合は`NetworkError`や`DecodingError`
    func send<Request, Response>(request: Request, retryAttemptCount: Int) -> AnyPublisher<Response, Error>
    where Request: APIRequest, Request.Response == Response {
        os_log(.debug, log: OSLog.network, "[%s] %s", request.method.rawValue, request.url)

        guard let request = request.asURLRequest() else {
            return Fail<Response, Error>(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }

        return dependency.urlSession
            .requestPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(data: data)
                }
                switch response.statusCode {
                case 200..<300:
                    return data
                default:
                    throw NetworkError.failed(statusCode: response.statusCode, data: data)
                }
            }
            .retry(retryAttemptCount)
            .decode(type: Response.self, decoder: dependency.jsonDecoder)
            .eraseToAnyPublisher()
    }
}

extension APIClientProtocol {
    /// `URLSession`を使ってリクエストを送り, `Response`にデコードする.
    /// - Parameters:
    ///   - request: リクエスト
    /// - Returns: 成功した場合`Response`が流れる. 失敗した場合は`NetworkError`や`DecodingError`
    func send<Request, Response>(request: Request) -> AnyPublisher<Response, Error>
    where Request: APIRequest, Request.Response == Response {
        return send(request: request, retryAttemptCount: 0)
    }
}
