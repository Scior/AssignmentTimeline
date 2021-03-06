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
            guard state.fetchingPageIndex == nil, state.hasNext else {
                // すでに取得中だったらリクエストは送らない
                return .none
            }

            let pageIndex = state.lastPageIndex + 1
            state.fetchingPageIndex = pageIndex

            if let accessToken = environment.accessTokenRepository.get() {
                return environment.timelineRepository
                    .getTimeline(request: .init(accessToken: accessToken, page: pageIndex))
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(TimelineAction.timelineResponse)
            } else {
                return .none
            }
        case let .hasReadItem(index):
            state.lastReadIndex = max(state.lastReadIndex, index)
            // 終わりに近づいたときに次を読む
            if state.lastReadIndex + 1 >= state.items.count {
                return Effect<TimelineAction, Never>(value: .fetchNextPage)
            } else {
                return .none
            }
        case .reloadItems:
            state = .empty

            return Effect<TimelineAction, Never>(value: .fetchNextPage)
        case let .timelineResponse(.success(response)):
            if let fetchingPageIndex = state.fetchingPageIndex {
                state.lastPageIndex = fetchingPageIndex
                state.fetchingPageIndex = nil
            }
            // 内容重複は考慮していない
            state.items += response

            return .none
        case .timelineResponse(.failure(.notFound)):
            // 404が返ってきた場合、それ以上リクエストを投げない
            state.hasNext = false
            state.fetchingPageIndex = nil

            return .none
        case .timelineResponse(.failure(_)):
            state.fetchingPageIndex = nil

            return .none
        }
    }
}
