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
    let image: String

    enum CodingKeys: String, CodingKey {
        case id = "sta_id"
        case name = "sta_name"
        case team = "sta_team"
        case latitude = "sta_lati"
        case longitude = "sta_long"
        case image = "sta_image"
    }
}

// MARK: - DataManager
class DataManager {
    static let shared = DataManager()
    
    private(set) var stadiums: [Stadium] = []
    
    private(set) var selectedStadium: Stadium?
    private(set) var userPassword: String = "password123"
    private(set) var userNickname: String = "박주홍쇼헤이"
    
    func setSelectedStadium(_ stadium: Stadium) {
        selectedStadium = stadium
    }
    
    func updateNickname(_ nickname: String) {
        userNickname = nickname
        print("닉네임 업데이트: \(nickname)")
    }
    
    func updatePassword(_ password: String) {
        userPassword = password
        print("비밀번호 업데이트")
    }
    
    func setStadiums(_ stadiums: [Stadium]) {
        self.stadiums = stadiums
    }
    
    // 선택 id로 stadium 찾기
    func selectStadium(byID id: Int) {
        if let stadium = stadiums.first(where: { $0.id == id }) {
            selectedStadium = stadium
        } else {
            print("Stadium with id \(id) not found")
        }
    }
}

class DataManager {
    static let shared = DataManager()
    private init() {}
    
    // 현재 선택된 경기장 데이터
    private(set) var selectedStadium: Stadium?
    
    // 데이터 설정 메서드
    func setSelectedStadium(_ stadium: Stadium) {
        selectedStadium = stadium
    }
}
