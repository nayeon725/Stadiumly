//
//  NicknameModalViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/2/25.
//

import UIKit
import SnapKit

// MARK: - NicknameModalViewController
class NicknameModalViewController: UIViewController {
    let textField = UITextField()
    let button = UIButton()
    
    var initialNickname: String = ""
    var onNicknameChanged: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let title = UILabel()
        title.text = "닉네임 변경"
        title.font = .boldSystemFont(ofSize: 18)

        let subtitle = UILabel()
        subtitle.text = "원하는 닉네임으로 변경"
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = .gray

        textField.placeholder = "변경할 닉네임을 적어주세요"
        textField.borderStyle = .roundedRect
        textField.text = initialNickname

        button.setTitle("닉네임 변경하기", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(changeNickname), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [title, subtitle, textField, button])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc func changeNickname() {
        let newNick = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newNick == nil || newNick!.isEmpty {
            // 닉네임 비어있을 때 확인 alert
            let alert = UIAlertController(title: "경고", message: "닉네임을 입력하지 않으시면 랜덤 닉네임이 생성됩니다. 계속하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                self.performNicknameUpdate(with: newNick)
            })
            self.present(alert, animated: true)
        } else {
            // 닉네임 입력됐으면 바로 변경
            performNicknameUpdate(with: newNick)
        }
    }

    private func performNicknameUpdate(with nickname: String?) {
        button.isEnabled = false
        button.alpha = 0.5

        DataManager.shared.updateNickname(nickname) { success, message in
            DispatchQueue.main.async {
                if success {
                    print("✅ 닉네임 변경 성공:", message ?? "")
                    self.dismiss(animated: true)
                } else {
                    print("❌ 실패:", message ?? "")
                    self.button.isEnabled = true
                    self.button.alpha = 1.0
                    let alert = UIAlertController(title: "오류", message: message ?? "닉네임 변경에 실패했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
