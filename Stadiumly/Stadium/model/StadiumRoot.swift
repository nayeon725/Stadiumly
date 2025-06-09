//
//  StadiumRoot.swift
//  Stadiumly
//
//  Created by 김나연 on 5/28/25.
//

import Foundation
import UIKit

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
    
    func updateNickname(_ nickname: String?, completion: @escaping (Bool, String?) -> Void) {
        var parameters: [String: Any] = [:]
        if let nickname = nickname {
            parameters["user_nick"] = nickname
        }
//        if let teamId = teamId {
//            parameters["user_like_staId"] = teamId
//        }

        APIService.shared.requestAuthorized("mypage/nickChange", method: .post, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(NicknameUpdateResponse.self, from: data)
                    if decoded.status == "success" {
                        self.userNickname = nickname ?? ""
                        completion(true, decoded.message)
                    } else {
                        completion(false, decoded.message)
                    }
                } catch {
                    print("디코딩 실패: \(error)")
                    completion(false, "응답 파싱 실패")
                }

            case .failure(let error):
                print("닉네임 변경 에러:", error.localizedDescription)
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        APIService.shared.requestAuthorized("mypage/pwdChange",
            method: .post,
            parameters: [
                "current_pwd": currentPassword,
                "new_pwd": newPassword
            ]) { result in
                switch result {
                case .success:
                    self.userPassword = newPassword // 서버 성공 시 로컬 저장 업데이트
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func setStadiums(_ stadiums: [Stadium]) {
        self.stadiums = stadiums
    }
    
    // 선택 id로 stadium 찾기
    func selectStadium(byID id: Int) {
        if let stadium = stadiums.first(where: { $0.id == id }) {
            selectedStadium = stadium
            APIService.shared.requestAuthorized("mypage/myteam", method: .post, parameters: ["user_like_staId" : stadium.id]) { result in
                switch result {
                case .success(let data):
                    print("응원하는 팀 변경: \(data)")
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
        } else {
            print("Stadium with id \(id) not found")
        }
    }
}
