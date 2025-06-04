//
//  StadiumCollectionCell.swift
//  Stadiumly
//
//  Created by 김나연 on 5/22/25.
//

import UIKit
import SnapKit

class StadiumCollectionCell: UICollectionViewCell {
    static let identifier = "Stadium"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        backgroundColor = .white
        contentView.backgroundColor = .clear
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // shadowView: 그림자용 뷰
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    // roundedContentView: corner radius와 콘텐츠용 뷰
    private let roundedContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let stadiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func setupUI() {
        contentView.backgroundColor = .clear

        contentView.addSubview(shadowView)
        shadowView.addSubview(roundedContentView)
        roundedContentView.addSubview(stadiumImageView)

        // 그림자 뷰 제약
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        // 둥근 뷰 제약
        roundedContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        // 이미지 뷰 제약
        stadiumImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
