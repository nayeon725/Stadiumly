//
//  DeleteDetailPageViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/31/25.
//

import UIKit
import SnapKit

class DeleteDetailPageViewController: UIViewController {

    private let titleLabel = UILabel()
    private let deleteLabel = UILabel()
    private let informationLabel = UILabel()
    private let deleteButton = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
    }
    
 
    func setupAddSubview() {
        [titleLabel, deleteLabel, informationLabel, deleteButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(65)
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        titleLabel.text = "회원탈퇴"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        informationLabel.text = "정말로 탈퇴 하시나요? \n\n 정보가 다 날라가고 \n 어쩌고저쩌고 블라블랍 블라블라블랍"
        informationLabel.numberOfLines = 0
        informationLabel.textAlignment = .center
        informationLabel.font = UIFont.systemFont(ofSize: 24)
        
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let atrributes: [NSAttributedString.Key : Any] = [
            .font: boldFont,
            .foregroundColor: UIColor.white
        ]
        let deleteAttributed = NSAttributedString(string: "탈퇴하기", attributes: atrributes)
        deleteButton.setAttributedTitle(deleteAttributed, for: .normal)
        deleteButton.backgroundColor = .darkGray
        deleteButton.layer.cornerRadius = 4
        deleteButton.addTarget(self, action: #selector(accountDelete), for: .touchUpInside)
    }
    
    
    @objc private func accountDelete() {
        let newAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.white
        ]
        let newTitle = NSAttributedString(string: "닫기", attributes: newAttributes)
        deleteButton.setAttributedTitle(newTitle, for: .normal)
        titleLabel.text = "회원탈퇴 완료"
        informationLabel.text = "회원 탈퇴가 완료되었습니다.\n\n 더 나은 서비스로 보답하겠습니다 \n감사합니다"
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let loginPage = LoginPageViewController()
            let nav = UINavigationController(rootViewController: loginPage)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        //추가로 버튼누르면 계정정보를 삭제하는것도 구현해야함
    }

}
