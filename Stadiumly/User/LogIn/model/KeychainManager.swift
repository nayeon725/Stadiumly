//
//  KeychainKeys.swift
//  Stadiumly
//
//  Created by 김나연 on 6/8/25.
//

import KeychainAccess

enum KeychainKeys {
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
}

final class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = Keychain(service: "com.yourapp.bundleid")

    func save(_ value: String, forKey key: String) {
        try? keychain.set(value, key: key)
    }

    func get(_ key: String) -> String? {
        try? keychain.get(key)
    }

    func remove(_ key: String) {
        try? keychain.remove(key)
    }

    func clearAll() {
        try? keychain.removeAll()
    }
}
