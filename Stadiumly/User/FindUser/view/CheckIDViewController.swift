//
//  CheckIDViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/4/25.
//

import UIKit
import SnapKit

class CheckIDViewController: UIViewController {

    var findedID: String = ""
    
    private var findedIDLabel = UILabel()
    private var resetPWLabel = UILabel()
    private var findIDTitle = UILabel()
    
    private var findIDStack = UIStackView()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle( "로그인하러 가기", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .systemGray4
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        return loginButton
    }()
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = .black
        return backButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
      
        setupTitle()
        setupCheckID()
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(findIDTitle.snp.centerY)
            make.width.height.equalTo(25)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(70)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetPWLabelTapped))
        resetPWLabel.addGestureRecognizer(tapGesture)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func resetPWLabelTapped() {
        // 화면 전환 동작 (예: pull)
        let findPWVC = FindPWViewController()
        navigationController?.pushViewController(findPWVC, animated: true)
    }
    
    @objc func loginButtonTapped() {
        let loginVC = LoginPageViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func setupTitle() {
        findIDTitle.text = "아이디 찾기"
        findIDTitle.textColor = .label
        findIDTitle.textAlignment = .center
        findIDTitle.isUserInteractionEnabled = true
        findIDTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        view.addSubview(findIDTitle)
        findIDTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupCheckID() {
        findedIDLabel.text = "찾으시는 아이디는\n\(findedID)입니다."
        findedIDLabel.textAlignment = .center
        findedIDLabel.font = .systemFont(ofSize: 25, weight: .bold)
        findedIDLabel.numberOfLines = 0
        
        let forgetPWLabel: UILabel = {
            let label = UILabel()
            label.text = "비밀번호를 잊으셨나요?"
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textAlignment = .center
            return label
        }()
        
        let loadUnderLine: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        resetPWLabel.text = "비밀번호 재설정하기"
        resetPWLabel.textAlignment = .center
        resetPWLabel.font = .systemFont(ofSize: 18, weight: .medium)
        resetPWLabel.attributedText = NSAttributedString(string: resetPWLabel.text!, attributes: loadUnderLine)
        resetPWLabel.isUserInteractionEnabled = true
        
        findIDStack = UIStackView(arrangedSubviews: [findedIDLabel, forgetPWLabel, resetPWLabel])
        findIDStack.axis = .vertical
        findIDStack.alignment = .center
        findIDStack.distribution = .fillEqually
        findIDStack.spacing = 20
        
        view.addSubview(findIDStack)
        findIDStack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
