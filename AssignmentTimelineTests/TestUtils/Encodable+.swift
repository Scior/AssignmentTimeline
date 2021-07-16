//
//  Encodable+.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/16.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        return try? encoder.encode(self)
    }
}
