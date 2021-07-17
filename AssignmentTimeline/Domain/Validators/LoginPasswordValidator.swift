//
//  LoginPasswordValidator.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import Foundation

protocol LoginPasswordValidatorProtocol {
    func validate(value: String) -> Result<String, ValidationError>
}

struct LoginPasswordValidator: Validator, EmailAddressValidatorProtocol {
    enum Const {
        static let regex: NSRegularExpression? = try? NSRegularExpression(pattern: "^[0-9a-zA-Z]{6,}$")
    }

    /// 有効なパスワード(6文字以上の英数字)か検証する.
    /// - Parameter value: 検証される文字列
    /// - Returns: 正しいなら`.success(value)`. 不正なら`.failure(ValidationError)`
    func validate(value: String) -> Result<String, ValidationError> {
        guard let regex = Const.regex else {
            assertionFailure("Invalid regex pattern")
            // いずれにせよAPIを叩くので、もしパターンが不正でもここでは通す
            return .success(value)
        }

        if regex.firstMatch(in: value, range: .init(location: 0, length: value.count)) != nil {
            return .success(value)
        } else {
            return .failure(.notPassed(reason: ""))
        }
    }
}
