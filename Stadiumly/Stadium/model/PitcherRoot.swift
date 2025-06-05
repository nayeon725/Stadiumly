//
//  PitcherRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 6/4/25.
//

import Foundation

struct PitcherRoot: Codable {
    let homePitcher: String
    let homeImg: String
    let homeTeam: String
    
    let awayPitcher: String
    let awayImg: String
    let awayTeam: String
    
    let startTime: String
    let weatherImage: String
    
    enum CodingKeys: String, CodingKey {
        case homePitcher = "pit_home_name"
        case homeImg = "pit_home_image"
        case homeTeam = "pit_home_team"
        
        case awayPitcher = "pit_away_name"
        case awayImg = "pit_away_image"
        case awayTeam = "pit_away_team"
        
        case startTime = "pit_game_time"
        case weatherImage = "pit_broad_image"
    }
}
