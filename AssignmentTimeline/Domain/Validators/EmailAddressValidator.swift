//
//  EmailAddressValidator.swift
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
    case notPassed(reason: String)

    var errorDescription: String? {
        switch self {
        case let .notPassed(reason):
            return "Validation failed because: \(reason)"
        }
    }
}

protocol EmailAddressValidatorProtocol {
    func validate(value: String) -> Result<String, ValidationError>
}

struct EmailAddressValidator: Validator, EmailAddressValidatorProtocol {
    func validate(value: String) -> Result<String, ValidationError> {
        return .failure(.notPassed(reason: ""))
    }
}
