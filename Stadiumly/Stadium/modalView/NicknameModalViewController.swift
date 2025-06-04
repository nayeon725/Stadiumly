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
        guard let newNick = textField.text, !newNick.isEmpty else { return }
        onNicknameChanged?(newNick)
        dismiss(animated: true)
    }
}
