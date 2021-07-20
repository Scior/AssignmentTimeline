//
//  TimelineReducer.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import ComposableArchitecture

extension SharedReducers {
    static let timeline = Reducer<TimelineState, TimelineAction, TimelineEnvironment> { state, action, environment in
        switch action {
        case .fetchNextPage:
            guard state.fetchingPageIndex == nil else {
                // すでに取得中だったらリクエストは送らない
                return .none
            }

            let pageIndex = state.lastPageIndex + 1
            state.fetchingPageIndex = pageIndex

            return environment.repository
                .getTimeline(request: .init(accessToken: "", page: pageIndex)) // FIXME:
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(TimelineAction.timelineResponse)
        case let .timelineResponse(.success(response)):
            if let fetchingPageIndex = state.fetchingPageIndex {
                state.lastPageIndex = fetchingPageIndex
                state.fetchingPageIndex = nil
            }
            // 内容重複は考慮していない
            state.items += response

            return .none
        case .timelineResponse(.failure):
            state.fetchingPageIndex = nil

            return .none
        }
    }
}
