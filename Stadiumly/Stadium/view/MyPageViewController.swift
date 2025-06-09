//
//  MyPageViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/31/25.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - MyPageViewController
class MyPageViewController: UIViewController {
    private var teamID: Int = 0
    private var teamName: String = ""
    private var userNickName: String = ""
    private var userID: String = ""
    private var userEmail: String = ""
    
    private let mypageTitle = UILabel()
    private let profileSection = UIStackView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emailSection = UIStackView()

    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let idLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailDataLabel = UILabel()
    private let headerDivider = UIView()
    private let footerDivider = UIView()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentVerticalAlignment = .bottom
        return button
    }()
    
    private let delAccButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원 탈퇴", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.contentVerticalAlignment = .bottom
        return button
    }()

    private enum SettingType: Int, CaseIterable {
        case nickname
        case password
        case team

        var title: String {
            switch self {
            case .nickname: return "닉네임 변경"
            case .password: return "비밀번호"
            case .team: return "응원하는 팀"
            }
        }

        var iconName: String {
            switch self {
            case .nickname: return "person"
            case .password: return "lock"
            case .team: return "star"
            }
        }
    }
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = .black
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delAccButton.addTarget(self, action: #selector(moveDeletePageVC), for: .touchUpInside)
        view.addSubview(delAccButton)
        delAccButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(35)
            make.leading.equalToSuperview().inset(35)
            make.height.equalTo(40)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(delAccButton.snp.top)
            make.leading.trailing.equalTo(delAccButton)
            make.height.equalTo(40)
        }
        
        loadUserData()
        setupTitle()
        setupProfileSection()
        setupEmailSection()
        setupHeaderDivider()
        setupFooterDivider()
        setupTableView()
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(mypageTitle.snp.centerY)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(25)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        backButton.addGestureRecognizer(tapGesture)
    }
    @objc private func moveDeletePageVC() {
        let deleteVC = DeleteAccountViewController()
        navigationController?.pushViewController(deleteVC, animated: true)
    }
    
    @objc func logoTapped() {
        // 화면 전환 동작 (예: pull)
        navigationController?.popViewController(animated: true)
    }
    
    private func loadUserData() {
        if let stadium = DataManager.shared.selectedStadium {
            teamID = stadium.id
            teamName = stadium.team
        }
        userNickName = DataManager.shared.userNickname
        userID = DataManager.shared.userLoginID
        userEmail = DataManager.shared.userEmail
    }

    private func setupTitle() {
        mypageTitle.text = "마이페이지"
        mypageTitle.textColor = .label
        mypageTitle.textAlignment = .center
        mypageTitle.isUserInteractionEnabled = true
        mypageTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)

        view.addSubview(mypageTitle)
        mypageTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupProfileSection() {
        view.addSubview(profileSection)
        profileSection.axis = .horizontal
        profileSection.spacing = 20
        profileSection.alignment = .center
        profileSection.distribution = .fill

        profileSection.snp.makeConstraints { make in
            make.top.equalTo(mypageTitle.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        if let imageUrlString = DataManager.shared.selectedStadium?.image,
           let imageUrl = URL(string: imageUrlString) {
            profileImageView.kf.setImage(with: imageUrl)
        } else {
            // fallback: 기본 로컬 이미지 (예: "defaultProfile")
            profileImageView.image = UIImage(named: "defaultProfile")
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
        }

        nicknameLabel.text = userNickName
        nicknameLabel.font = .boldSystemFont(ofSize: 22)

        idLabel.text = userID
        idLabel.font = .systemFont(ofSize: 16)

        let labelsStack = UIStackView(arrangedSubviews: [nicknameLabel, idLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 10

        profileSection.addArrangedSubview(profileImageView)
        profileSection.addArrangedSubview(labelsStack)
    }
    
    private func setupEmailSection() {
        view.addSubview(emailSection)
        emailSection.axis = .horizontal
        emailSection.distribution = .equalSpacing
        
        emailLabel.text = "이메일"
        emailLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        emailDataLabel.text = userEmail
        emailDataLabel.font = .systemFont(ofSize: 20)
        
        emailSection.addArrangedSubview(emailLabel)
        emailSection.addArrangedSubview(emailDataLabel)
        
        emailSection.snp.makeConstraints { make in
            make.top.equalTo(profileSection.snp.bottom).offset(20)
            make.leading.trailing.equalTo(profileSection)
            make.height.equalTo(50)
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerDivider.snp.bottom).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(footerDivider.snp.top)
        }
    }
    
    private func updateProfileNickname(_ nickname: String) {
        userNickName = nickname
        nicknameLabel.text = nickname
        DataManager.shared.updateNickname(nickname) { success, message in
            DispatchQueue.main.async {
                if success {
                    print("✅ 닉네임 변경 성공:", message ?? "")
                    self.dismiss(animated: true)
                } else {
                    print("❌ 실패:", message ?? "")
                    let alert = UIAlertController(title: "오류", message: message ?? "닉네임 변경에 실패했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func updateProfileTeam(id: Int, name: String) {
        teamID = id
        teamName = name

        // 선택한 팀의 Stadium 객체 설정
        DataManager.shared.selectStadium(byID: id)

        // 이미지 URL 설정
        if let imageUrlString = DataManager.shared.selectedStadium?.image,
           let imageUrl = URL(string: imageUrlString) {
            profileImageView.kf.setImage(with: imageUrl)
        } else {
            print("이미지 URL이 유효하지 않거나 없음")
        }
        
        tableView.reloadData()
    }
    
    private func setupHeaderDivider() {
        headerDivider.backgroundColor = .systemGray5
        view.addSubview(headerDivider)

        headerDivider.snp.makeConstraints { make in
            make.top.equalTo(emailSection.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupFooterDivider() {
        footerDivider.backgroundColor = .systemGray5
        view.addSubview(footerDivider)

        footerDivider.snp.makeConstraints { make in
            make.bottom.equalTo(logoutButton.snp.top)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = SettingType(rawValue: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = type.title
        content.textProperties.font = .systemFont(ofSize: 20, weight: .medium)
        content.image = UIImage(systemName: type.iconName)
        if type == .team {
            content.secondaryText = teamName
            content.secondaryTextProperties.color = .systemGray
            content.secondaryTextProperties.font = .systemFont(ofSize: 17)
        }
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = SettingType(rawValue: indexPath.row) else { return }

        switch type {
        case .nickname:
            let nicknameVC = NicknameModalViewController()
            nicknameVC.modalPresentationStyle = .pageSheet
            if let sheet = nicknameVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            nicknameVC.initialNickname = userNickName
            nicknameVC.onNicknameChanged = { [weak self] newNick in
                self?.updateProfileNickname(newNick)
            }
            present(nicknameVC, animated: true)
        case .password:
            let passwordVC = PasswordModalViewController()
            passwordVC.modalPresentationStyle = .pageSheet
            if let sheet = passwordVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            present(passwordVC, animated: true)
        case .team:
            let teamVC = TeamModalViewController()
            teamVC.modalPresentationStyle = .pageSheet
            if let sheet = teamVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            teamVC.selectedTeam = teamName
            teamVC.onTeamChanged = { [weak self] selectedTeamName in
                guard let self = self else { return }

                // 이름으로 stadium 찾아서
                if let stadium = DataManager.shared.stadiums.first(where: { $0.team == selectedTeamName }) {
                    self.updateProfileTeam(id: stadium.id, name: stadium.team)
                } else {
                    print("선택한 팀 이름과 매칭되는 stadium을 찾지 못했습니다: \(selectedTeamName)")
                }
            }
            present(teamVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}


