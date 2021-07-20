//
//  AccessTokenRepository.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import KeychainAccess

protocol AccessTokenRepositoryProtocol {
    func save(token: String)
    func get() -> String?
    func clear()
}

struct AccessTokenRepository: AccessTokenRepositoryProtocol {
    enum Const {
        static let service = "com.flyingalpaca.AssignmentTimeline"
        static let key = "access_token"
    }

    static let shared = AccessTokenRepository()
    private let keychain = Keychain(service: Const.service)

    func save(token: String) {
        keychain[Const.key] = token
    }

    func get() -> String? {
        return keychain[string: Const.key]
    }

    func clear() {
        keychain[Const.key] = nil
    }
}
