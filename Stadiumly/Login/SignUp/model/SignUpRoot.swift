//
//  EmailUniqueRequest.swift
//  Stadiumly
//
//  Created by 김나연 on 6/6/25.
//

import Foundation

struct EmailUniqueRequest: Codable {
    let email: String
}

struct EmailUniqueResponse: Codable {
    let message: String
    let status: String
}

struct EmailTokenCheckRequest: Codable {
    let email: String
    let emailToken: String
}

struct EmailTokenCheckResponse: Codable {
    let message: String
    let status: String
}

struct SignUpRequest: Codable {
    let email: String
    let id: String
    let password: String
    let nick: String?
    let team: Int?
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
        case id = "user_cus_id"
        case password = "user_pw"
        case nick = "user_nick"
        case team = "user_like_staId"
    }
}

struct SignUpResponse: Codable {
    let message: String
    let status: String
}
