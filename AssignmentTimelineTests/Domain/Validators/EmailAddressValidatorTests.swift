//
//  EmailAddressValidatorTests.swift
//  AssignmentTimelineTests
//
//  Created by Fujino Suita on 2021/07/17.
//

import XCTest
@testable import AssignmentTimeline

final class EmailAddressValidatorTests: XCTestCase {
    let validator = EmailAddressValidator()

    // MARK: - Test cases

    func testValidateWithValidAddresses() {
        // See: https://code.iamcal.com/php/rfc822/tests/
        // See: https://datatracker.ietf.org/doc/html/rfc5322
        let addresses: [String] = [
            "first.last@hoge.com",
            "1234567890123456789012345678901234567890123456789012345678901234@hoge.org",
            "first.last@123.hoge.org",
            "first.last@3com.com"
        ]

        for address in addresses {
            XCTAssertEqual(
                try validator.validate(value: address).get(),
                address,
                "Validation is supposed to succeed with: \(address)"
            )
        }
    }

    func testValidateWithInvalidAddresses() {
        // See: https://code.iamcal.com/php/rfc822/tests/
        // See: https://datatracker.ietf.org/doc/html/rfc5322
        let addresses: [String] = [
            "first.last@sub.do,com",
            "first\\@last@hoge.org",
            ".first.last@hoge.com",
            "first..last@hoge.org"
        ]

        for address in addresses {
            guard case .failure(.notPassed) = validator.validate(value: address) else {
                return XCTFail("Validation is supposed to fail with: \(address)")
            }
        }
    }
}
