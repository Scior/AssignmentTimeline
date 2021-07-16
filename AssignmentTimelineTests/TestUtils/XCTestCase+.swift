//
//  XCTestCase+.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/16.
//

import Combine
import XCTest

extension XCTestCase {
    /// Publisherが値を返すまで待ち, 期待した値と同じかを確認する.
    /// - Parameters:
    ///   - expected: 返されるべき値
    ///   - publisher: テスト対象の`AnyPublisher`
    ///   - timeout: タイムアウト値. デフォルトで1s
    func waitForPublishing<V, E>(_ expected: V, publisher: AnyPublisher<V, E>, timeout: TimeInterval = 1.0)
        where V: Equatable {
        let expectation = XCTestExpectation(description: "To be \(expected)")
        var cancellables = Set<AnyCancellable>()
        publisher
            .sink { result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Failed with an error: \(error)")
                }
            } receiveValue: { value in
                XCTAssertEqual(expected, value)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
    }

    /// PublisherがErrorを返すまで待ち, 期待したerrorかを確認する.
    /// - Parameters:
    ///   - publisher: テスト対象の`AnyPublisher`
    ///   - timeout: タイムアウト値. デフォルトで1s
    ///   - condition: Publisherが返したerrorに対するテスト条件
    func waitForPublishingError<V, E>(publisher: AnyPublisher<V, E>, timeout: TimeInterval = 1.0, condition: @escaping (Error) -> Bool) {
        let expectation = XCTestExpectation(description: "To fulfill a condition")
        var cancellables = Set<AnyCancellable>()
        publisher
            .sink { result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssert(condition(error), "The condition is not satisfied")
                    expectation.fulfill()
                }
            } receiveValue: { value in
                XCTFail("Failed with a value: \(value)")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
    }
}

