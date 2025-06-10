//
//  KeychainKeys.swift
//  Stadiumly
//
//  Created by 김나연 on 6/8/25.
//

import Foundation
import Security

enum KeychainKeys {
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
}

final class KeychainManager {
    static let shared = KeychainManager()

    // Save
    func save(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            // 먼저 기존 값 삭제 (중복 방지)
            remove(key)

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecAttrService as String: "org.kimny54.stadiumly",
                kSecValueData as String: data
            ]

            SecItemAdd(query as CFDictionary, nil)
        }
    }

    // Get
    func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    // Remove specific key
    func remove(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }

    // Remove all keys
    func clearAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "org.kimny54.stadiumly" // KeychainAccess에서 지정했던 서비스명
        ]
        SecItemDelete(query as CFDictionary)
    }
}

