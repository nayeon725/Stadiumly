//
//  ParkingLotRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 5/24/25.
//


import Foundation

struct ParkingLotRoot: Codable{
    let GetParkingInfo: GetParkingInfo
}

struct GetParkingInfo: Codable {
    let row: [Row]
}

struct Row: Codable {
    let PKLT_NM: String                         // 주차장 이름
    var BSC_PRK_CRG: Double               // 기본 단위 요금
    var BSC_PRK_HR: Double                 // 기본 단위 시간(분)
    let ADD_PRK_CRG: Double               // 추가 단위 요금
    let ADD_PRK_HR: Double                 // 추가 단위 시간(분)
    let TPKCT: Double                            // 총 주차면
    let OPER_SE_NM: String                   // 운영구분명(시간제)
    let ADDR: String                               // 주소
    let NOW_PRK_VHCL_CNT: Double    // 현재 주차 차량 수
    let PAY_YN_NM: String                     // 유무료구분명(유료/무료)
    let PRK_STTS_NM: String                 // 주차현황 정보 제공 여부
    let TELNO: String?                           // 전화번호
}
