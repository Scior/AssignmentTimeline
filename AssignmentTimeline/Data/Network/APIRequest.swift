//
//  APIRequest.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/16.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIRequest {
    associatedtype Response: Decodable
    var url: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
}

// MARK: - Default values

extension APIRequest {
    var queryItems: [URLQueryItem]? {
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
        request.httpMethod = method.rawValue
        return request
    }
}
