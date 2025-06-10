//
//  DetailedPageViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/25/25.
//

import UIKit
import SnapKit
import Kingfisher

//식당 디테일 페이지
class DetailedPlayerViewController: UIViewController {
    

    var operatingHoursText: String? = nil
    
    var detailData: PlayerRecommand?
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let locationButton = UIButton()
    private let locationLabel = UILabel()
    private let menuLabel = UILabel()
    private let menuButton = UIButton()
    private let operatingHoursLabel = UILabel()
    private let hoursButton = UIButton()
    private let phoneNumberLabel = UILabel()
    private let xmarkButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        if let detail = detailData {
            configureImage(with: detail)
        }
    }
    
    
    func setupAddSubview() {
        [imageView, nameLabel, locationLabel, menuLabel, operatingHoursLabel, locationButton, menuButton, hoursButton, xmarkButton, phoneNumberLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        xmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(20)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(200)
        }
        locationButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(23)
            $0.leading.equalTo(locationButton.snp.trailing).offset(5)
        }
        menuButton.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        menuLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(23)
            $0.leading.equalTo(menuButton.snp.trailing).offset(5)
        }
        hoursButton.snp.makeConstraints {
            $0.top.equalTo(menuLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(menuLabel.snp.bottom).offset(18)
            $0.leading.equalTo(hoursButton.snp.trailing).offset(5)
        }
    }
    
    func configureUI() {
        guard let foodData = detailData else { return }
        view.backgroundColor = .white
        nameLabel.text = foodData.reco_name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        locationLabel.text = "위치 : \(foodData.reco_add)"
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        menuLabel.text = "메뉴 : \(foodData.reco_menu)"
        menuLabel.font = UIFont.systemFont(ofSize: 15)
        phoneNumberLabel.text = "전화번호 : \(foodData.reco_tp)"
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 15)
//        operatingHoursLabel.text = "운영시간 : "
        locationButton.setImage(UIImage(named: "location"), for: .normal)
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        hoursButton.setImage(UIImage(named: "phone"), for: .normal)
        xmarkButton.setImage(UIImage(named: "xmark"), for: .normal)
        xmarkButton.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        imageView.contentMode = .scaleAspectFit
    }
    
    @objc private func dismissPage() {
        dismiss(animated: true)
    }
    
    func configureImage(with recommand: PlayerRecommand) {
        if let url = URL(string: recommand.reco_image) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "Photo"))
        }
    }
}
