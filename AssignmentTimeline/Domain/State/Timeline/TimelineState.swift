//
//  TimelineState.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

struct TimelineState: Equatable {
    var items: [TimelineItem]
    var lastPageIndex: Int
    var fetchingPageIndex: Int?

    static let empty = TimelineState(items: [], lastPageIndex: 0, fetchingPageIndex: nil)
}
