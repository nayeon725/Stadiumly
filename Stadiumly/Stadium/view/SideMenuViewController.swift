//
//  SideMenuViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/26/25.
//

import UIKit
import SnapKit

class SideMenuViewController: UIViewController {
    
    let menuNames: [String] = ["구단 선택", "먹거리 검색", "구장 주변 주차장 찾기", "마이페이지"]
    let titleImage = UIImageView()
    let menuList = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        view.addSubview(menuList)
        
        setupMenuUI()
        
        menuList.delegate = self
        menuList.dataSource = self
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
            let nextVC = MyPageViewController()
            navigationController?.pushViewController(nextVC, animated: false)
        default : break
        }
    }
}
