//
//  APIRequest.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/16.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    var url: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

// MARK: - Default values

extension APIRequest {
    var queryItems: [URLQueryItem]? {
        return nil
    }

    var body: Data? {
        return nil
    }
}

// MARK: - Methods

extension APIRequest {
    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: url)
        components?.queryItems = queryItems
        guard let url = components?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        request.httpMethod = method.rawValue

        return request
    }
}
