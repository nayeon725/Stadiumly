//
//  FoodListRoot.swift
//  Stadiumly
//
//  Created by Hee  on 5/29/25.
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
