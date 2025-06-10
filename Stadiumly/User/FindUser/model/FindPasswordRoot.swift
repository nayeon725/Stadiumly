//
//  Untitled.swift
//  Stadiumly
//
//  Created by 김나연 on 6/10/25.
//

import Foundation

//["user_email" : insertedEmail]

struct FindPWEmailRequest: Codable {
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
    }
}

struct FindPWEmailResponse: Codable {
    let status: String
    let message: String
}

// ["user_email" : insertedEmail, "token" : insertedCode]
struct FindPWTokenCheckRequest: Codable {
    let email: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
        case token
    }
}

struct FindPWTokenCheckResponse: Codable {
    let status: String
    let message: String
}

struct ChangePWRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
        case password = "new_pwd"
    }
}

struct ChangePWResponse: Codable {
    let status: String
    let message: String
}

