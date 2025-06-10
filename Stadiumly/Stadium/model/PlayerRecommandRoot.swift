//
//  PlayerRecommandRoot.swift
//  Stadiumly
//
//  Created by Hee  on 6/9/25.
//

import Foundation


struct PlayerRecommand: Codable {
    
    let reco_add: String
    let reco_image: String
    let reco_name: String
    let reco_menu: String
    let reco_player: String?
    let reco_tp: String
    let reco_stadiumId: Int

}
