//
//  APIService.swift
//  Stadiumly
//
//  Created by 김나연 on 6/8/25.
//

import Alamofire
import UIKit

final class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "http://20.41.113.4"

    // 로그인 요청
    func login(userID: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/auth/userid-login"
        let params = ["user_cus_id": userID, "user_pwd": password]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let token):
                    KeychainManager.shared.save(token.access_token, forKey: KeychainKeys.accessToken)
                    KeychainManager.shared.save(token.refresh_token, forKey: KeychainKeys.refreshToken)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // 인증 요청 (자동 갱신 포함)
    func requestAuthorized(_ endpoint: String,
                           method: HTTPMethod = .get,
                           parameters: Parameters? = nil,
                           completion: @escaping (Result<Data, AFError>) -> Void) {
        guard let accessToken = KeychainManager.shared.get(KeychainKeys.accessToken) else {
            completion(.failure(AFError.explicitlyCancelled))
            return
        }

        let url = baseURL + "\(endpoint)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                if response.response?.statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success:
                            self.requestAuthorized(endpoint, method: method, parameters: parameters, completion: completion)
                        case .failure(let error):
                            completion(.failure(error as? AFError ?? AFError.explicitlyCancelled))
                        }
                    }
                } else {
                    completion(response.result)
                }
            }
    }

    // 토큰 갱신 요청
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = KeychainManager.shared.get(KeychainKeys.refreshToken) else {
            completion(.failure(AFError.invalidURL(url: "No refresh token")))
            return
        }

        let url = baseURL + "/auth/refresh"
        let parameters = ["refreshToken": refreshToken]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let token):
                    KeychainManager.shared.save(token.access_token, forKey: KeychainKeys.accessToken)
                    KeychainManager.shared.save(token.refresh_token, forKey: KeychainKeys.refreshToken)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
//    func updateNickname(_ nickname: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let token = KeychainManager.shared.get(KeychainKeys.accessToken) else {
//            completion(.failure(NSError(domain: "NoToken", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token 없음"])))
//            return
//        }
//
//        let url = "\(baseURL)/nickChange"
//        let parameters: [String: Any] = [
//            "user_nick": nickname
//        ]
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }


    
//    func updatePassword(current: String, new: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let token = KeychainManager.shared.get(KeychainKeys.accessToken) else {
//            completion(.failure(NSError(domain: "NoToken", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token 없음"])))
//            return
//        }
//
//        let url = "\(baseURL)/pwdChange"
//        let parameters: [String: Any] = [
//            "current_pwd": current,
//            "new_pwd": new
//        ]
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }

    
//    func updateMyTeam(stadiumID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let token = KeychainManager.shared.get(KeychainKeys.accessToken) else {
//            completion(.failure(NSError(domain: "NoToken", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token 없음"])))
//            return
//        }
//
//        let url = "\(baseURL)/myteam"
//        let parameters: [String: Any] = [
//            "user_like_staId": stadiumID
//        ]
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }

}

