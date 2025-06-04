//
//  FoodListRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 5/31/25.
//

import Foundation


struct KakaoSearch: Codable {
    let documents: [Place]
}

struct Place: Codable {
    let place_name: String
    let place_url: String
    let x: String
    let y: String
    
}
