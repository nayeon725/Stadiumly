//
//  MenuListCell.swift
//  Stadiumly
//
//  Created by 김나연 on 5/29/25.
//

import UIKit
import SnapKit

class MenuListCell: UITableViewCell {
    static let identifier = "MenuListCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    let menuListLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(menuListLabel)
        
        // 이미지 뷰 제약
        menuListLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
