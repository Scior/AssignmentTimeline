//
//  TimelineRepositoryTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/19.
//

import Combine
import XCTest
@testable import AssignmentTimeline

final class TimelineRepositoryTests: XCTestCase {
    var apiClientMock: APIClientMock!
    var timelineRepository: TimelineRepository!

    override func setUp() {
        apiClientMock = APIClientMock()
        timelineRepository = TimelineRepository(dependency: .init(client: apiClientMock))
    }

    // MARK: - Test cases

    func testGetTimelineWithResponse() {
        let response: TimelineResponse = [
            .init(
                id: 10,
                type: .bigImage,
                image: "hoge",
                link: "aaa",
                title: nil,
                pickCount: 50,
                topComment: .init(
                    comment: "comment",
                    user: .init(id: 11, name: "bbb", image: "ccc")
                ),
                pickUsers: [.init(id: 12, name: "DDD", image: "mmm")]
            )
        ]
        apiClientMock.publisher = justAnyError(response)

        waitForPublishing(
            response,
            publisher: timelineRepository.getTimeline(request: .init(accessToken: "abcde", page: 1))
        )
    }

    func testGetTimelineWithUnauthorizedError() {
            let responseStatusCode = 401
            apiClientMock.publisher = failAnyError(APIClient.NetworkError.failed(statusCode: responseStatusCode, data: .init()))

            waitForPublishingError(publisher: timelineRepository.getTimeline(
                request: .init(accessToken: "abcde", page: 1)
            )) { error in
                return error == .unauthorized
            }
    }

    func testGetTimelineWithNotFoundError() {
            let responseStatusCode = 404
            apiClientMock.publisher = failAnyError(APIClient.NetworkError.failed(statusCode: responseStatusCode, data: .init()))

            waitForPublishingError(publisher: timelineRepository.getTimeline(
                request: .init(accessToken: "abcde", page: 1)
            )) { error in
                return error == .notFound
            }
    }

    func testGetTimelineWithOtherError() {
            let responseStatusCode = 500
            apiClientMock.publisher = failAnyError(APIClient.NetworkError.failed(statusCode: responseStatusCode, data: .init()))

            waitForPublishingError(publisher: timelineRepository.getTimeline(
                request: .init(accessToken: "abcde", page: 1)
            )) { error in
                return error == .others
            }
    }
}
