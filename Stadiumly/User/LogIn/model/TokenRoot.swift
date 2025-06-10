//
//  TokenRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 6/8/25.
//

import Foundation

struct TokenResponse: Decodable {
    let access_token: String
    let refresh_token: String
}


