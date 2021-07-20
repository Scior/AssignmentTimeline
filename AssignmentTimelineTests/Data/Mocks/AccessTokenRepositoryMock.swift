//
//  AccessTokenRepositoryMock.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/20.
//

@testable import AssignmentTimeline

final class AccessTokenRepositoryMock: AccessTokenRepositoryProtocol {
    var saveReceivedValue: String?
    var getReturnValue: String!
    func save(token: String) {
        saveReceivedValue = token
    }
    func get() -> String? {
        return getReturnValue
    }
    func clear() {}
}
