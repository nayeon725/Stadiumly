//
//  UserRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 6/9/25.
//

import Foundation

struct User : Codable {
    let teamID: Int
    let nick: String
    let email: String
//    let stadium: StadiumInfo

    enum CodingKeys : String, CodingKey {
        case teamID = "user_like_staId"
        case nick = "user_nick"
        case email = "user_email"
//        case stadium
    }
}

//struct StadiumInfo : Codable {
//    let image: String
//    let teamName: String
//
//    enum CodingKeys : String, CodingKey {
//        case image = "sta_image"
//        case teamName = "sta_teams"
//    }
//}
