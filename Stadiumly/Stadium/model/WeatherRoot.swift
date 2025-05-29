//
//  WeatherRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 5/27/25.
//

import Foundation

struct WeatherRoot: Codable {
    let weather: [Weather]
    let rain: Rain?
    let main: Main
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Rain: Codable {
    let oneHour: Double
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct Main: Codable {
    let temp: Double
}
