//
//  TimelineStoreTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/21.
//

import Combine
import ComposableArchitecture
import XCTest
@testable import AssignmentTimeline

final class TimelineStoreTests: XCTestCase {
    private var timelineRepositoryMock: TimelineRepositoryMock!
    private var accessTokenRepositoryMock: AccessTokenRepositoryMock!
    private var testStore: TestStore<TimelineState, TimelineState, TimelineAction, TimelineAction, TimelineEnvironment>!

    private let dummyItem = TimelineItem(
        id: 1,
        type: .bigImage,
        image: "",
        link: nil,
        title: "hoge",
        pickCount: 1234,
        topComment: .init(comment: "comment!", user: .init(id: 90, name: "taro", image: "hoge")),
        pickUsers: [
            .init(id: 5, name: "uuu", image: ""),
            .init(id: 7, name: "vvv", image: "vvv")
        ]
    )
    private let dummyItem2 = TimelineItem(
        id: 2,
        type: .smallImage,
        image: "",
        link: nil,
        title: "fuga",
        pickCount: 5000,
        topComment: .init(comment: "comment!", user: .init(id: 90, name: "taro", image: "hoge")),
        pickUsers: [
            .init(id: 6, name: "nnn", image: ""),
            .init(id: 8, name: "zzz", image: "zzz")
        ]
    )

    override func setUp() {
        timelineRepositoryMock = .init()
        accessTokenRepositoryMock = .init()
        resetTestStore(initialState: .empty)
    }

    private func resetTestStore(initialState: TimelineState) {
        testStore = TestStore(
            initialState: initialState,
            reducer: SharedReducers.timeline,
            environment: .init(
                timelineRepository: timelineRepositoryMock,
                accessTokenRepository: accessTokenRepositoryMock,
                mainQueue: .immediate
            )
        )
    }

    // MARK: - Test cases

    func testFetchItemsSuccessively() {
        let response = TimelineResponse([dummyItem, dummyItem2, dummyItem])
        timelineRepositoryMock.getTimelineReturnValue = Just(response)
            .setFailureType(to: TimelineRepository.TimelineError.self)
            .eraseToAnyPublisher()
        accessTokenRepositoryMock.getReturnValue = "token"

        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 1
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items = response
            $0.lastPageIndex = 1
            $0.fetchingPageIndex = nil
        }
        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 2
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items += response
            $0.lastPageIndex = 2
            $0.fetchingPageIndex = nil
        }
    }

    func testFetchItemsWithError() {
        let response = TimelineResponse([dummyItem, dummyItem2, dummyItem])
        let successResponse = Just(response)
            .setFailureType(to: TimelineRepository.TimelineError.self)
            .eraseToAnyPublisher()
        timelineRepositoryMock.getTimelineReturnValue = successResponse
        accessTokenRepositoryMock.getReturnValue = "token"

        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 1
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items = response
            $0.lastPageIndex = 1
            $0.fetchingPageIndex = nil
        }

        // 2ページ目失敗

        timelineRepositoryMock.getTimelineReturnValue =
            Fail<TimelineRequest.Response, TimelineRepository.TimelineError>(error: TimelineRepository.TimelineError.others)
            .eraseToAnyPublisher()
        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 2
        }
        testStore.receive(.timelineResponse(.failure(.others))) {
            $0.fetchingPageIndex = nil
        }

        // 再度2ページ目のフェッチ

        timelineRepositoryMock.getTimelineReturnValue = successResponse
        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 2
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items += response
            $0.lastPageIndex = 2
            $0.fetchingPageIndex = nil
        }
    }

    func testFetchItemsWithNotFoundError() {
        accessTokenRepositoryMock.getReturnValue = "token"
        let response = TimelineResponse([dummyItem, dummyItem2, dummyItem])
        let successResponse = Just(response)
            .setFailureType(to: TimelineRepository.TimelineError.self)
            .eraseToAnyPublisher()

        // notFoundで失敗

        timelineRepositoryMock.getTimelineReturnValue =
            Fail<TimelineRequest.Response, TimelineRepository.TimelineError>(error: TimelineRepository.TimelineError.notFound)
            .eraseToAnyPublisher()
        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 1
        }
        testStore.receive(.timelineResponse(.failure(.notFound))) {
            $0.fetchingPageIndex = nil
            $0.hasNext = false
        }

        // 再度フェッチしても何も起きない

        timelineRepositoryMock.getTimelineReturnValue = successResponse
        testStore.send(.fetchNextPage)
    }

    func testReloadItems() {
        let response = TimelineResponse([dummyItem, dummyItem2, dummyItem])
        let successResponse = Just(response)
            .setFailureType(to: TimelineRepository.TimelineError.self)
            .eraseToAnyPublisher()
        timelineRepositoryMock.getTimelineReturnValue = successResponse
        accessTokenRepositoryMock.getReturnValue = "token"

        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 1
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items = response
            $0.lastPageIndex = 1
            $0.fetchingPageIndex = nil
        }

        // リロード

        testStore.send(.reloadItems) {
            $0 = .empty
        }
        testStore.receive(.fetchNextPage) {
            $0.fetchingPageIndex = 1
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items = response
            $0.lastPageIndex = 1
            $0.fetchingPageIndex = nil
        }
    }

    func testHasReadItem() {
        let response = TimelineResponse([dummyItem, dummyItem2, dummyItem])
        let successResponse = Just(response)
            .setFailureType(to: TimelineRepository.TimelineError.self)
            .eraseToAnyPublisher()
        timelineRepositoryMock.getTimelineReturnValue = successResponse
        accessTokenRepositoryMock.getReturnValue = "token"

        testStore.send(.fetchNextPage) {
            $0.fetchingPageIndex = 1
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items = response
            $0.lastPageIndex = 1
            $0.fetchingPageIndex = nil
        }

        // 既読をつける

        testStore.send(.hasReadItem(index: 0))
        testStore.send(.hasReadItem(index: 2)) {
            $0.lastReadIndex = 2
        }
        testStore.receive(.fetchNextPage) {
            $0.fetchingPageIndex = 2
        }
        testStore.receive(.timelineResponse(.success(response))) {
            $0.items += response
            $0.lastPageIndex = 2
            $0.fetchingPageIndex = nil
        }
    }
}

private extension TimelineStoreTests {
    final class TimelineRepositoryMock: TimelineRepositoryProtocol {
        var getTimelineReturnValue: AnyPublisher<TimelineRequest.Response, TimelineRepository.TimelineError>!
        func getTimeline(request: TimelineRequest) -> AnyPublisher<TimelineRequest.Response, TimelineRepository.TimelineError> {
            return getTimelineReturnValue
        }
    }
}

