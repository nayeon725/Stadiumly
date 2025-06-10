//
//  TermsOfServiceViewController.swift
//  Stadiumly
//
//  Created by Hee  on 6/5/25.
//

import UIKit
import SnapKit

class TermsOfServiceViewController: UIViewController {
    
    private let privacyLabel = UILabel()
    private let privacySubLabel = UILabel()
    private let oneLabel = UILabel()
    private let oneSubLabel = UILabel()
    private let twoLabel = UILabel()
    private let twoSubLabel = UILabel()
    private let threeLabel = UILabel()
    private let threeSubLabel = UILabel()
    private let fourLabel = UILabel()
    private let fourSubLabel = UILabel()
    private let fiveLabel = UILabel()
    private let fiveSubLabel = UILabel()
    private let sixLabel = UILabel()
    private let sixSubLabel = UILabel()
    private let sevenLabel = UILabel()
    private let sevenSubLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
    }
    func setupAddSubview() {
        [privacyLabel, privacySubLabel, oneLabel, oneSubLabel, twoLabel, twoSubLabel, threeLabel, threeSubLabel, fourLabel, fourSubLabel, fiveLabel, fiveSubLabel, sixLabel, sixSubLabel, sevenLabel, sevenSubLabel].forEach {
            view.addSubview($0)
        }
    }
    func setupConstraints() {
        privacyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        privacySubLabel.snp.makeConstraints {
            $0.top.equalTo(privacyLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        oneLabel.snp.makeConstraints {
            $0.top.equalTo(privacySubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        oneSubLabel.snp.makeConstraints {
            $0.top.equalTo(oneLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
        }
        twoLabel.snp.makeConstraints {
            $0.top.equalTo(oneSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        twoSubLabel.snp.makeConstraints {
            $0.top.equalTo(twoLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
        }
        threeLabel.snp.makeConstraints {
            $0.top.equalTo(twoSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        threeSubLabel.snp.makeConstraints {
            $0.top.equalTo(threeLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-20)
        }
        fourLabel.snp.makeConstraints {
            $0.top.equalTo(threeSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        fourSubLabel.snp.makeConstraints {
            $0.top.equalTo(fourLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
        }
        fiveLabel.snp.makeConstraints {
            $0.top.equalTo(fourSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        fiveSubLabel.snp.makeConstraints {
            $0.top.equalTo(fiveLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-20)
        }
        sixLabel.snp.makeConstraints {
            $0.top.equalTo(fiveSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        sixSubLabel.snp.makeConstraints {
            $0.top.equalTo(sixLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
        }
        sevenLabel.snp.makeConstraints {
            $0.top.equalTo(sixSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        sevenSubLabel.snp.makeConstraints {
            $0.top.equalTo(sevenLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    func configureUI(){
        view.backgroundColor = .white
        privacyLabel.text = "개인정보 처리방침"
        privacyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        privacySubLabel.text = "본 개인정보 처리방침은 [Stadiumly] 앱 이용자들의 개인정보를 어떻게 수집, 활용, 관리하는지 알려드립니다."
        privacySubLabel.font = UIFont.systemFont(ofSize: 15)
        privacySubLabel.numberOfLines = 0
        privacySubLabel.lineBreakMode = .byWordWrapping
        oneLabel.text = "1. 수집하는 개인정보"
        oneLabel.font = UIFont.boldSystemFont(ofSize: 20)
        oneSubLabel.text = "아이디, 비밀번호"
        oneSubLabel.font = UIFont.systemFont(ofSize: 15)
        twoLabel.text = "2. 개인정보 처리 목적"
        twoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        twoSubLabel.text = "앱 서비스 제공 및 개선"
        twoSubLabel.font = UIFont.systemFont(ofSize: 15)
        threeLabel.text = "3. 제3자 공유 및 제공"
        threeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        threeSubLabel.text = "이용자의 동의 없이 개인정보를 제3자에게 공유하지 않습니다."
        threeSubLabel.font = UIFont.systemFont(ofSize: 15)
        threeSubLabel.numberOfLines = 0
        threeSubLabel.lineBreakMode = .byWordWrapping
        fourLabel.text = "4. 개인정보 파기"
        fourLabel.font = UIFont.boldSystemFont(ofSize: 20)
        fourSubLabel.text = "회원 탈퇴 시 지체 없이 개인정보를 파기합니다."
        fourSubLabel.font = UIFont.systemFont(ofSize: 15)
        fiveLabel.text = "5. 이용자 권리 행사"
        fiveLabel.font = UIFont.boldSystemFont(ofSize: 20)
        fiveSubLabel.text = "개인정보 열람, 수정, 삭제, 처리 정지 등 권리를 행사할 수 있습니다."
        fiveSubLabel.font = UIFont.systemFont(ofSize: 15)
        fiveSubLabel.numberOfLines = 0
        fiveSubLabel.lineBreakMode = .byWordWrapping
        sixLabel.text = "6. 개인정보 보호 책임자"
        sixLabel.font = UIFont.boldSystemFont(ofSize: 20)
        sixSubLabel.text = "[Stadiumly]"
        sixSubLabel.font = UIFont.systemFont(ofSize: 15)
        sevenLabel.text = "7. 개인정보처리방침 변경"
        sevenLabel.font = UIFont.boldSystemFont(ofSize: 20)
        sevenSubLabel.text = "개인정보처리방침이 변경될 경우, 앱 내 공지사항을 통해 알려드립니다."
        sevenSubLabel.font = UIFont.systemFont(ofSize: 15)
        sevenSubLabel.numberOfLines = 0
        sevenSubLabel.lineBreakMode = .byWordWrapping
    }
}
