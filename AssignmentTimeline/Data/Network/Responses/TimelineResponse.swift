//
//  TimelineResponse.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import Foundation

typealias TimelineResponse = [TimelineItem]

struct TimelineItem: Decodable, Equatable {
    enum CellType: String, Decodable {
        case bigImage = "BIG_IMAGE"
        case smallImage = "SMALL_IMAGE"
        case banner = "BANNER"
    }

    let id: Int
    let type: CellType
    let image: String
    let link: String?
    let title: String?
    let pickCount: Int?
    let topComment: Comment?
    let pickUsers: [User]?

}

struct Comment: Decodable, Equatable {
    let comment: String
    let user: User
}

struct User: Decodable, Equatable {
    let id: Int
    let name: String
    let image: String
}
