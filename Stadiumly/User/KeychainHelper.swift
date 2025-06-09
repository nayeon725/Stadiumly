//
//  KeychainHelper.swift
//  Stadiumly
//
//  Created by Hee  on 6/8/25.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private let accessTokenKey = "accessToken"
    
    func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        //기존에 있는 경우 삭제
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: accessTokenKey ] as CFDictionary
            SecItemDelete(query)
        //새 토큰 저장
        let addQuery = [kSecClass: kSecClassGenericPassword,
                        kSecAttrAccount : accessTokenKey,
                        kSecValueData : data] as CFDictionary
        SecItemAdd(addQuery, nil)
    }
    func loadToken() -> String? {
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: accessTokenKey,
                kSecReturnData: kCFBooleanTrue!,
                kSecMatchLimit: kSecMatchLimitOne] as CFDictionary
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    func deleteToken() {
        let query = [ kSecClass: kSecClassGenericPassword,
                      kSecAttrAccount: accessTokenKey] as CFDictionary
        SecItemDelete(query)
    }
}

