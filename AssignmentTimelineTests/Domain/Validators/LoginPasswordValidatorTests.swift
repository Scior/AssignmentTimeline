//
//  LoginPasswordValidatorTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/17.
//

import XCTest
@testable import AssignmentTimeline

final class LoginPasswordValidatorTests: XCTestCase {
    let validator = LoginPasswordValidator()

    // MARK: - Test cases

    func testValidateWithValidPasswords() {
        let passwords: [String] = [
            "000000",
            "password",
            "PASSWORD",
            "1a2B3c"
        ]

        for password in passwords {
            XCTAssertEqual(
                try validator.validate(value: password).get(),
                password,
                "Validation is supposed to succeed with: \(password)"
            )
        }
    }

    func testValidateWithInvalidPasswords() {
        let passwords: [String] = [
            "",
            "1",
            "A",
            "12345",
            "abcde",
            "ABCDE",
            "あかさたなはまや",
            "123AB@dmv",
            "0123-456-7890",
            "      "
        ]

        for password in passwords {
            guard case .failure(.notPassed) = validator.validate(value: password) else {
                return XCTFail("Validation is supposed to fail with: \(password)")
            }
        }
    }
}
