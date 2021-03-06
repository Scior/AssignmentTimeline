//
//  EmailAddressValidator.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import Foundation

protocol EmailAddressValidatorProtocol {
    func validate(value: String) -> Result<String, ValidationError>
}

struct EmailAddressValidator: Validator, EmailAddressValidatorProtocol {
    enum Const {
        /// RFC5322を参考にした正規表現パターン. "の有無や.の位置については厳密に弾けない
        /// See: https://emailregex.com/
        static let regex: NSRegularExpression? = try? NSRegularExpression(
            pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        )
    }

    /// Emailアドレスとして正しいか検証する.
    /// - Parameter value: 検証される文字列
    /// - Returns: 正しいなら`.success(value)`. 不正なら`.failure(ValidationError)`
    func validate(value: String) -> Result<String, ValidationError> {
        guard let regex = Const.regex else {
            assertionFailure("Invalid regex pattern")
            // サーバーサイドのvalidationもあるので、もしパターンが不正でもここでは通す
            return .success(value)
        }

        if regex.firstMatch(in: value, range: .init(location: 0, length: value.count)) != nil {
            return .success(value)
        } else {
            return .failure(.notPassed)
        }
    }
}
