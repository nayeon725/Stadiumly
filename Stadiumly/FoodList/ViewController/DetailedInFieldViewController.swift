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
class DetailedInFieldViewController: UIViewController {
    

    var operatingHoursText: String? = nil
    
    var detailData: Cafeteria?
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let locationButton = UIButton()
    private let locationLabel = UILabel()
    private let menuLabel = UILabel()
    private let menuButton = UIButton()
    private let operatingHoursLabel = UILabel()
    private let hoursButton = UIButton()
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
        [imageView, nameLabel, locationLabel, menuLabel, operatingHoursLabel, locationButton, menuButton, hoursButton, xmarkButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        xmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(20)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(200)
        }
        locationButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.equalTo(locationButton.snp.trailing).offset(5)
        }
        menuButton.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        menuLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(20)
            $0.leading.equalTo(menuButton.snp.trailing).offset(5)
        }
        hoursButton.snp.makeConstraints {
            $0.top.equalTo(menuLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        operatingHoursLabel.snp.makeConstraints {
            $0.top.equalTo(menuLabel.snp.bottom).offset(20)
            $0.leading.equalTo(hoursButton.snp.trailing).offset(5)
        }
    }
    
    func configureUI() {
        guard let foodData = detailData else { return }
        view.backgroundColor = .white
        nameLabel.text = foodData.cafe_name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        locationLabel.text = "위치 : \(foodData.cafe_location)"
        menuLabel.text = "메뉴 : "
        operatingHoursLabel.text = "운영시간 : "
        locationButton.setImage(UIImage(named: "location"), for: .normal)
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        hoursButton.setImage(UIImage(named: "clock"), for: .normal)
        xmarkButton.setImage(UIImage(named: "xmark"), for: .normal)
        xmarkButton.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
    }
    
    @objc private func dismissPage() {
        dismiss(animated: true)
    }
    
    func configureImage(with cafeteria: Cafeteria) {
        if let url = URL(string: cafeteria.cafe_image) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "Photo"))
        }
    }
}

