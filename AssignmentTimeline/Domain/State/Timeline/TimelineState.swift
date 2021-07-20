//
//  TimelineState.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

struct TimelineState: Equatable {
    var items: [TimelineItem]
    var lastPageIndex: Int
    var lastReadIndex: Int
    var hasNext: Bool
    var fetchingPageIndex: Int?

    static let empty = TimelineState(
        items: [],
        lastPageIndex: 0,
        lastReadIndex: 0,
        hasNext: true,
        fetchingPageIndex: nil
    )
}
