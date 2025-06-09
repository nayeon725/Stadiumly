//
//  InFieldCollectionViewCell.swift
//  Stadiumly
//
//  Created by Hee  on 5/25/25.
//

import UIKit
import SnapKit
import Kingfisher

//구장 내 먹거리 컬렉션뷰 셀
class InFieldCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "inFieldcell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddSubview()
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddSubview() {
        contentView.addSubview(imageView)
        imageView.addSubview(nameLabel)
    }

    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    func configureUI() {
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.white,
            .foregroundColor: UIColor.white,
            .strokeWidth: -2.0,
            .font: UIFont.systemFont(ofSize: 23, weight: .bold)
        ]

        nameLabel.attributedText = NSAttributedString(string: "구장 내 먹거리", attributes: strokeTextAttributes)
    }

    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    func configureImage(with cafeteria: Cafeteria) {
        nameLabel.text = cafeteria.cafe_name
        if let url = URL(string: cafeteria.cafe_image) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "Photo"))
        }
    }
}
