//
//  TimelineRequest.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import Foundation

struct TimelineRequest: APIRequest {
    typealias Response = TimelineResponse
    let path = "/timeline"
    let method: HTTPMethod = .get
    let accessToken: String
    let page: Int

    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "access_token", value: accessToken),
            .init(name: "page", value: String(page))
        ]
    }
}
