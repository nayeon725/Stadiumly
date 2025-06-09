//
//  DataManager.swift
//  Stadiumly
//
//  Created by 김나연 on 6/9/25.
//

import Foundation

// MARK: - DataManager
class DataManager {

    static let shared = DataManager()
    
    private(set) var stadiums: [Stadium] = []
    
    private(set) var selectedStadium: Stadium?
    private(set) var userPassword: String = ""
    private(set) var userNickname: String = ""
    private(set) var userEmail: String = ""
    private(set) var userLoginID: String = ""
    private(set) var userTeamID: Int = 0
    
    func setUser(_ user: User) {
        self.userNickname = user.nick
        self.userEmail = user.email
        self.userLoginID = user.loginID
        if let stadium = stadiums.first(where: { $0.id == user.teamID }) {
            self.setSelectedStadium(stadium)
        } else {
            print("⚠️ teamID에 해당하는 stadium을 찾지 못함")
        }
    }
    
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

        APIService.shared.requestAuthorized("/user/mypage/nickChange", method: .post, parameters: parameters) { result in
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
        APIService.shared.requestAuthorized("/user/mypage/pwdChange",
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
            APIService.shared.requestAuthorized("/user/mypage/myteam", method: .post, parameters: ["user_like_staId" : stadium.id]) { result in
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
