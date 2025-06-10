//
//  SideMenuViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/26/25.
//

import UIKit
import SnapKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    private let menuNames: [String] = ["구단 선택", "먹거리 검색", "구장 주변 주차장 찾기", "마이페이지"]
    private let titleImage = UIImageView()
    private let menuList = UITableView()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentVerticalAlignment = .bottom
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        view.addSubview(menuList)
        
        setupMenuUI()
        
        menuList.delegate = self
        menuList.dataSource = self
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logoutButtonTapped() {
        APIService.shared.requestAuthorized("/auth/logout", method: .post) { result in
            switch result {
            case .success:
                print("로그아웃 성공")
                // 토큰 제거 + 사용자 정보 초기화
                DataManager.shared.logout()
                self.showAlert(title: "완료", message: "로그아웃 되었습니다.") {
                    // 화면 이동
                    let loginVC = LoginPageViewController()
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            case .failure(let error):
                print("로그아웃 실패 \(error)")
                self.showAlert(title: "오류 발생", message: "로그아웃에 실패하였습니다.")
            }
        }
    }
    
    private func setupMenuUI() {
        titleImage.image = UIImage(named: "STADIUMLY_short")
        titleImage.contentMode = .scaleAspectFit
        titleImage.isUserInteractionEnabled = true
        view.addSubview(titleImage)
        
        menuList.register(MenuListCell.self, forCellReuseIdentifier: MenuListCell.identifier)
        menuList.backgroundColor = .clear
        menuList.separatorStyle = .singleLine
        menuList.separatorInset = .zero
        view.addSubview(menuList)
        view.addSubview(logoutButton)
        
        titleImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        menuList.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
        }
    }
    
    private func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        })
        present(alert, animated: true)
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuListCell.identifier, for: indexPath) as! MenuListCell
        cell.menuListLabel.text = menuNames[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let nextVC = ViewController()
            navigationController?.pushViewController(nextVC, animated: false)
        case 1:
            let nextVC = FoodListViewController()
            navigationController?.pushViewController(nextVC, animated: false)
        case 2:
            let nextVC = ParkingLotViewController()
            navigationController?.pushViewController(nextVC, animated: false)
        case 3:
            print("❓ Access Token: \(KeychainManager.shared.get(KeychainKeys.accessToken) ?? "없음")\n")
            print("✅ Refresh Token: \(KeychainManager.shared.get(KeychainKeys.refreshToken) ?? "없음")")
            if KeychainManager.shared.get(KeychainKeys.accessToken) == nil || KeychainManager.shared.get(KeychainKeys.refreshToken) == nil {
                self.showAlert(title: "오류", message: "로그인 후 이용해주세요.") {
                    SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true)
                }
            } else {
                let nextVC = MyPageViewController()
                navigationController?.pushViewController(nextVC, animated: false)
            }
        default : break
        }
    }
}
