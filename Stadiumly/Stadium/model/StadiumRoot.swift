//
//  StadiumRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 5/28/25.
//

import Foundation

struct Stadium: Codable {
    let id: Int
    let name: String
    let team: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "sta_id"
        case name = "sta_name"
        case team = "sta_team"
        case latitude = "sta_lati"
        case longitude = "sta_long"
    }
}
