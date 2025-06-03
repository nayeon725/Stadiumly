//
//  LoginPageCollectionViewCell.swift
//  Stadiumly
//
//  Created by Hee  on 6/3/25.
//

import UIKit
import SnapKit

//로그인 페이지 컬렉션뷰 셀
class LoginPageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "loginCell"
    private let imageView = UIImageView()
    
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
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    func configureUI() {
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }
    
    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    
}
