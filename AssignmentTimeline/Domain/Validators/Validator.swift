//
//  Validator.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import Foundation

/// Validator共通のI/Fを定義するプロトコル
protocol Validator {
    associatedtype Value
    func validate(value: Value) -> Result<Value, ValidationError>
}

enum ValidationError: LocalizedError {
    case notPassed

    var errorDescription: String? {
        switch self {
        case .notPassed:
            return "Validation failed"
        }
    }
}
