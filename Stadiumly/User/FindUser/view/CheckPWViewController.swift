//
//  CheckPWViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/10/25.
//

import UIKit
import SnapKit

//회원가입 완료 페이지
class CheckPWViewController: UIViewController {
   
    private let titleLabel = UILabel()
    private let completionLabel = UILabel()
    private let singUpButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        
    }
    
    func setupAddSubview() {
        [titleLabel, completionLabel, singUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.centerX.equalToSuperview()
        }
        completionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(300)
            $0.centerX.equalToSuperview()
        }
        singUpButton.snp.makeConstraints {
            $0.top.equalTo(completionLabel.snp.bottom).offset(280)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(65)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        titleLabel.text = "비밀번호 찾기"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        completionLabel.text = "비밀번호가\n변경되었습니다."
        completionLabel.font = UIFont.boldSystemFont(ofSize: 40)
        completionLabel.numberOfLines = 0
        completionLabel.textAlignment = .center
        singUpButton.backgroundColor = .systemGray4
        singUpButton.setTitle("로그인하러 가기", for: .normal)
        singUpButton.setTitleColor(.black, for: .normal)
        singUpButton.layer.cornerRadius = 20
        singUpButton.addTarget(self, action: #selector(moveToLoginVC), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func moveToLoginVC() {
        let loginVC = LoginPageViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
