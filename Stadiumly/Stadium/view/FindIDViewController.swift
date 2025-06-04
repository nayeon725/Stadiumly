//
//  FindIDViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/4/25.
//

import UIKit
import SnapKit

class FindIDViewController: UIViewController {
    
    private var insertedEmail: String = ""
    private var insertedCode: String = ""
    
    private var emailStack = UIStackView()
    private var codeStack = UIStackView()
    
    private var descLabel = UILabel()
    private var findIDTitle = UILabel()
    
    private let changePWButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTitle()
        setupEmailSection()
        setupCodeSection()
        setupButton()
        
        changePWButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        findIDTitle.addGestureRecognizer(tapGesture)
    }
    
    @objc func logoTapped() {
        // 화면 전환 동작 (예: pull)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped() {
        let checkVC = CheckIDViewController()
        navigationController?.pushViewController(checkVC, animated: true)
    }
    
    private func setupTitle() {
        findIDTitle.text = "아이디 찾기"
        findIDTitle.textColor = .label
        findIDTitle.textAlignment = .center
        findIDTitle.isUserInteractionEnabled = true
        findIDTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        view.addSubview(findIDTitle)
        findIDTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descLabel.text = "가입 시 등록하신 이메일을 입력해주세요."
        descLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        descLabel.numberOfLines = 0
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(findIDTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().offset(20)
        }
    }
    
    // 이메일 섹션 아이템
    private func setupEmailSection() {
        let titleLabel = UILabel()
        titleLabel.text = "이메일 입력"
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        let emailTF = UITextField()
        emailTF.placeholder = "이메일 입력"
        emailTF.borderStyle = .roundedRect
        
        let emailButton = UIButton()
        emailButton.setTitle("인증번호 받기", for: .normal)
        emailButton.setTitleColor(.black, for: .normal)
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 5
        emailButton.layer.masksToBounds = true
        
        emailTF.setContentHuggingPriority(.defaultLow, for: .horizontal)
        emailButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let horizontalStack = UIStackView(arrangedSubviews: [emailTF, emailButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .leading
        horizontalStack.distribution = .fillProportionally
        horizontalStack.spacing = 8
        
        emailStack = UIStackView(arrangedSubviews: [titleLabel, horizontalStack])
        emailStack.axis = .vertical
        emailStack.alignment = .fill
        emailStack.spacing = 10
        
        view.addSubview(emailStack)
        emailStack.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        emailTF.snp.makeConstraints { make in
            make.width.equalTo(emailButton.snp.width).multipliedBy(5.0 / 3.0)
        }
    }
    
    private func setupCodeSection() {
        let titleLabel = UILabel()
        titleLabel.text = "인증메일을 발송했습니다.\n메일 확인 후 인증번호를 입력해주세요."
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        let codeTF = UITextField()
        codeTF.placeholder = "인증번호 입력"
        codeTF.borderStyle = .roundedRect
        
        let codeButton = UIButton()
        codeButton.setTitle("인증번호 확인", for: .normal)
        codeButton.setTitleColor(.black, for: .normal)
        codeButton.backgroundColor = .systemGray4
        codeButton.layer.cornerRadius = 5
        codeButton.layer.masksToBounds = true
        
        codeTF.setContentHuggingPriority(.defaultLow, for: .horizontal)
        codeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let horizontalStack = UIStackView(arrangedSubviews: [codeTF, codeButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .leading
        horizontalStack.distribution = .fillProportionally
        horizontalStack.spacing = 8
        
        codeStack = UIStackView(arrangedSubviews: [titleLabel, horizontalStack])
        codeStack.axis = .vertical
        codeStack.alignment = .fill
        codeStack.spacing = 10
        
        view.addSubview(codeStack)
        codeStack.snp.makeConstraints { make in
            make.top.equalTo(emailStack.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(emailStack.snp.horizontalEdges)
        }
        
        codeTF.snp.makeConstraints { make in
            make.width.equalTo(codeButton.snp.width).multipliedBy(5.0 / 3.0)
        }
    }
    
    private func setupButton() {
        changePWButton.setTitle("아이디 찾기", for: .normal)
        changePWButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        changePWButton.setTitleColor(.black, for: .normal)
        changePWButton.backgroundColor = .systemGray4
        changePWButton.layer.cornerRadius = 10
        changePWButton.layer.masksToBounds = true
        
        view.addSubview(changePWButton)
        changePWButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalToSuperview().inset(70)
            make.height.equalTo(50)
        }
    }
}
