//
//  DeleteAccountViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/31/25.
//

import UIKit
import SnapKit

class NoHighlightButton: UIButton {
    override var isHighlighted: Bool {
        get { return false }
        set { /* 무시 */ }
    }
}
class DeleteAccountViewController: UIViewController {
    
    private var dropdownButton = UIButton(type: .custom)
    private let dropdownTableView = UITableView()
    private let options = ["앱이 싫어서", "이제 야구가꼴보기싫어서", "앱이 불편해서", "다른앱을 깔려고", "앱이 불친절해서"]
    private var isDropdownVisible = false

    private let stadiumlyLogo = UIImageView()
    private let deleteLabel = UILabel()
    private let deleteSubLabel = UILabel()
    private let deleteAccountButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
    }
    

    func setupAddSubview() {
        [stadiumlyLogo, deleteLabel,deleteSubLabel, deleteAccountButton, dropdownButton, dropdownTableView].forEach {
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        stadiumlyLogo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(20)
        }
        deleteLabel.snp.makeConstraints {
            $0.top.equalTo(stadiumlyLogo.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(35)
        }
        deleteSubLabel.snp.makeConstraints {
            $0.top.equalTo(deleteLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(35)
        }
        deleteAccountButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(65)
        }
        dropdownButton.snp.makeConstraints {
            $0.top.equalTo(deleteSubLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(35)
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
        dropdownTableView.snp.makeConstraints {
            $0.top.equalTo(dropdownButton.snp.bottom)
            $0.centerX.equalTo(dropdownButton.snp.centerX)
            $0.width.equalTo(dropdownButton.snp.width)
            $0.height.equalTo(44 * options.count)
        }
    }
    

    func configureUI() {
        view.backgroundColor = .white
        deleteLabel.text = "STADLUMLY를"
        deleteSubLabel.text = "탈퇴하시는 이유를 알려주세요."
        deleteAccountButton.setTitle("회원탈퇴", for: .normal)
        deleteAccountButton.setTitleColor(.black, for: .normal)
        deleteAccountButton.backgroundColor = .lightGray
        deleteAccountButton.layer.cornerRadius = 20
        deleteAccountButton.addTarget(self, action: #selector(movetoVC), for: .touchUpInside)
        stadiumlyLogo.image = UIImage(named: "stadiumlyLogo")

        dropdownButton.backgroundColor = .white
        dropdownButton.layer.borderColor = UIColor.black.cgColor
        dropdownButton.layer.borderWidth = 1
        dropdownButton.setTitle("사유를선택해주세요", for: .normal)
        dropdownButton.setTitleColor(.black, for: .normal)
        dropdownButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        dropdownButton.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        dropdownButton.tintColor = .black
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.setTitleColor(.black, for: .highlighted)
        dropdownButton.imageView?.contentMode = .scaleAspectFit
        dropdownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dropdownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 260, bottom: 0, right: 0)
        dropdownButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)

        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderColor = UIColor.black.cgColor
        dropdownTableView.layer.borderWidth = 0.5
        dropdownTableView.rowHeight = 44
        dropdownTableView.separatorInset = .zero
    }

    func setupProperty() {
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        dropdownTableView.isHidden = !isDropdownVisible
    }

    @objc private func movetoVC()  {
        let detailPageVC = DeleteDetailPageViewController()
        detailPageVC.modalPresentationStyle = .pageSheet
        
        if let modalView = detailPageVC.sheetPresentationController {
            modalView.detents = [.medium()] // 화면 반 정도
            modalView.prefersGrabberVisible = true // 위에 손잡이 표시
            modalView.preferredCornerRadius = 20
           }
           present(detailPageVC, animated: true)
    }
}
extension DeleteAccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdownButton.setTitle(options[indexPath.row], for: .normal)
        isDropdownVisible = false
        dropdownTableView.isHidden = true
    }
    
    
}
