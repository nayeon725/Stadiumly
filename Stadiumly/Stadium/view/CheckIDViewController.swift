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
    
    private var findIDStack = UIStackView()
    private let loginButton = UIButton()
    
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
      
        setupCheckID()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        resetPWLabel.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func logoTapped() {
        // 화면 전환 동작 (예: pull)
        let findPWVC = FindPWViewController()
        navigationController?.pushViewController(findPWVC, animated: true)
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
