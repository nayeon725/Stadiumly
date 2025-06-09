//
//  DeleteDetailPageViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/31/25.
//

import UIKit
import SnapKit
import Alamofire

class DeleteDetailPageViewController: UIViewController {

    private let titleLabel = UILabel()
    private let deleteLabel = UILabel()
    private let informationLabel = UILabel()
    private let deleteButton = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
    }
    
 
    func setupAddSubview() {
        [titleLabel, deleteLabel, informationLabel, deleteButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(65)
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        titleLabel.text = "회원탈퇴"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        informationLabel.text = "정말로 탈퇴 하시나요? \n\n 정보가 다 날라가고 \n 어쩌고저쩌고 블라블랍 블라블라블랍"
        informationLabel.numberOfLines = 0
        informationLabel.textAlignment = .center
        informationLabel.font = UIFont.systemFont(ofSize: 24)
        
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let atrributes: [NSAttributedString.Key : Any] = [
            .font: boldFont,
            .foregroundColor: UIColor.white
        ]
        let deleteAttributed = NSAttributedString(string: "탈퇴하기", attributes: atrributes)
        deleteButton.setAttributedTitle(deleteAttributed, for: .normal)
        deleteButton.backgroundColor = .darkGray
        deleteButton.layer.cornerRadius = 4
        deleteButton.addTarget(self, action: #selector(accountDelete), for: .touchUpInside)
    }
    
    
    @objc private func accountDelete() {
       
        deleteUserAccount()
        let newAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.white
        ]
        let newTitle = NSAttributedString(string: "닫기", attributes: newAttributes)
        deleteButton.setAttributedTitle(newTitle, for: .normal)
        titleLabel.text = "회원탈퇴 완료"
        informationLabel.text = "회원 탈퇴가 완료되었습니다.\n\n 더 나은 서비스로 보답하겠습니다 \n감사합니다"
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let loginPage = LoginPageViewController()
            let nav = UINavigationController(rootViewController: loginPage)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }

}
//MARK: - 회원탈퇴 API
extension DeleteDetailPageViewController {
    
    private func deleteUserAccount() {
        guard let accessToken = KeychainManager.shared.get(KeychainKeys.accessToken) else {
            print("❌ 토큰없음 - 삭제불가")
            return
        }
        let endpt = "http://localhost:3000/auth/delete-user"
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)",
            "Content-Type" : "application/json"
        ]
        AF.request(endpt, method: .post, headers: headers)
            .validate(statusCode: 201..<300)
            .response { response in
                switch response.result {
                case .success:
                    print("✅ 유저 삭제 성공")
                    KeychainManager.shared.clearAll()
                    print("🔑 Keychain 토큰 삭제 완료")
                    print("📦 탈퇴 요청에 사용된 토큰: \(accessToken)")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        print("❌ 유저 삭제 실패 - 상태코드 \(statusCode)")
                    } else {
                        print("❌ 요청 실패 : \(error.localizedDescription)")
                    }
                }
            }
    }
}
