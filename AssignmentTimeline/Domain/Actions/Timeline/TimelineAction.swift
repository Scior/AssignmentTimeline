//
//  TimelineAction.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

enum TimelineAction: Equatable {
    case fetchNextPage
    case timelineResponse(Result<TimelineResponse, TimelineRepository.TimelineError>)
}
