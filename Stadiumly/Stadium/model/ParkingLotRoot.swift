//
//  ParkingLotRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 5/24/25.
//


import Foundation

struct ParkingLotRoot: Codable {
    let documents: [ParkingPlace]
}

struct ParkingPlace: Codable {
    let address_name: String // 구 주소
    let category_group_code: String // 카테고리코드
    let place_name: String // 주차장이름
    let place_url: String // url
    let road_address_name: String // 신 주소
    let x: String
    let y: String
}
