//
//  TeamModalViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/2/25.
//

import UIKit
import SnapKit

// MARK: - TeamModalViewController
class TeamModalViewController: UIViewController {
    let teams = ["KIA 타이거즈", "두산 베어스",  "롯데 자이언츠", "삼성 라이온즈", "SSG 랜더스", "NC 다이노스", "LG  트윈스", "KT 위즈", "키움 히어로즈", "한화 이글스"]
    var selectedTeam: String = "키움 히어로즈" // 기본 선택
    var onTeamChanged: ((String) -> Void)?
    
    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let title = UILabel()
        title.text = "응원하는 팀 변경"
        title.font = .boldSystemFont(ofSize: 18)
        title.textAlignment = .center

        let subtitle = UILabel()
        subtitle.text = "\(selectedTeam) 응원 중"
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textAlignment = .center

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10

        for team in teams {
            let button = UIButton(type: .system)
            button.setTitle(team, for: .normal)
            button.contentHorizontalAlignment = .left
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.tintColor = .systemGray
            button.addTarget(self, action: #selector(selectTeam(_:)), for: .touchUpInside)
            if team == selectedTeam {
                button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                button.tintColor = .black
            }
            buttons.append(button)
            stack.addArrangedSubview(button)
        }

        let mainStack = UIStackView(arrangedSubviews: [title, subtitle, stack])
        mainStack.axis = .vertical
        mainStack.spacing = 15

        view.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc func selectTeam(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        selectedTeam = title

        for button in buttons {
            if button == sender {
                button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                button.tintColor = .black
            } else {
                button.setImage(UIImage(systemName: "circle"), for: .normal)
                button.tintColor = .systemGray
            }
        }

        onTeamChanged?(selectedTeam)
        dismiss(animated: true)
    }
}
