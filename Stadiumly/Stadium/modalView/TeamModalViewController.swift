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
    private let teams : [(id: Int, teamName: String)] = [(1, "키움 히어로즈"), (2, "SSG 랜더스"), (3, "롯데 자이언츠"), (4, "KT 위즈"), (5, "삼성 라이온즈"), (6, "NC 다이노스"), (7, "두산 베어스"), (8, "LG 트윈스"), (9, "KIA 타이거즈"), (10, "한화 이글스"), (11, "No team")]
    var selectedTeam: String? {
        didSet {
            if let team = selectedTeam {
                subtitleLabel.text = "\(team) 응원 중!"
                if let found = teams.first(where: { $0.teamName == team }) {
                    onTeamChanged?(team)
                    DataManager.shared.selectStadium(byID: found.id)
                    dismiss(animated: true)
                }
            } else {
                subtitleLabel.text = "응원할 팀을 선택해주세요"
            }
        }
    }
    var onTeamChanged: ((String) -> Void)?
    
    private var buttons: [UIButton] = []
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let title = UILabel()
        title.text = "응원하는 팀 변경"
        title.font = .boldSystemFont(ofSize: 18)
        title.textAlignment = .center
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        
        for team in teams {
            let button = UIButton(type: .system)
            button.setTitle(team.teamName, for: .normal)
            button.contentHorizontalAlignment = .left
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.tintColor = .systemGray
            button.addTarget(self, action: #selector(selectTeam(_:)), for: .touchUpInside)
            if team.teamName == selectedTeam {
                button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                button.tintColor = .black
            }
            buttons.append(button)
            stack.addArrangedSubview(button)
        }
        
        let mainStack = UIStackView(arrangedSubviews: [title, subtitleLabel, stack])
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
    }
}
