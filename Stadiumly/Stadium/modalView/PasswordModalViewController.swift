//
//  PasswordModalViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/2/25.
//

import UIKit
import SnapKit

// MARK: - PasswordModalViewController
class PasswordModalViewController: UIViewController {
    let currentPasswordField = UITextField()
    let newPasswordField = UITextField()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let title = UILabel()
        title.text = "비밀번호 변경"
        title.font = .boldSystemFont(ofSize: 18)

        let subtitle = UILabel()
        subtitle.text = "영문, 숫자, 특수문자 중 2가지 이상 조합하여 8~16자"
        subtitle.font = .systemFont(ofSize: 12)
        subtitle.textColor = .gray

        currentPasswordField.placeholder = "기존 비밀번호 입력"
        currentPasswordField.isSecureTextEntry = true
        currentPasswordField.borderStyle = .roundedRect

        newPasswordField.placeholder = "새로운 비밀번호 입력"
        newPasswordField.isSecureTextEntry = true
        newPasswordField.borderStyle = .roundedRect

        button.setTitle("비밀번호 변경하기", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [title, subtitle, currentPasswordField, newPasswordField, button])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc func changePassword() {
        guard let current = currentPasswordField.text, !current.isEmpty,
              let newPass = newPasswordField.text, !newPass.isEmpty else {
            // 빈 칸 체크 알림 등 추가 가능
            return
        }
        
        button.isEnabled = false
        button.alpha = 0.5
        
        DataManager.shared.updatePassword(currentPassword: current, newPassword: newPass) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.button.isEnabled = true
                self.button.alpha = 1
                
                switch result {
                case .success:
                    self.dismiss(animated: true)
                case .failure:
                    let alert = UIAlertController(title: "오류", message: "기존 비밀번호가 일치하지 않거나 변경에 실패했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
