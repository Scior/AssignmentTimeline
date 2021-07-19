//
//  LoginRequest.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import Foundation

struct LoginRequest: APIRequest {
    typealias Response = LoginResponse
    struct Body: Encodable {
        let mailAddress: String
        let password: String
    }

    let path = "/login"
    let method: HTTPMethod = .post
    let requestBody: Body

    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(requestBody)
    }
}
