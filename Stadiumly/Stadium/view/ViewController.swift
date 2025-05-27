//
//  ViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/21/25.
//

import UIKit
import SnapKit
import MapKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let space: CGFloat = 10
    let columns: CGFloat = 2
    let sectionInset: CGFloat = 10
    
    let clubImages = ["kiwoom", "doosanbears", "giants", "ktwiz", "ssglanders", "hanwhaeagles", "samsunglions", "lgtwins", "ncdinos", "kiatigers" ]
    //    let clubNames = ["키움 히어로즈", "두산 베어스", "롯데 자이언츠", "케이티 위즈", "SSG 랜더스", "한화 이글스", "삼성 라이온즈", "엘지 트윈스", "엔씨 다이노스", "기아 타이거즈"]
    
    let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = UIImage(named: "STADIUMLY_short")
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(StadiumCollectionCell.self, forCellWithReuseIdentifier: StadiumCollectionCell.identifier)
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        view.addSubview(titleImage)
        view.addSubview(collectionView)
        
        if let image = UIImage(named: "STADIUMLY_short") {
            let imageRatio = image.size.height / image.size.width
            
            titleImage.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalTo(titleImage.snp.width).multipliedBy(imageRatio)
            }
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        clubImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StadiumCollectionCell.identifier, for: indexPath) as! StadiumCollectionCell
        cell.imageView.image = UIImage(named: clubImages[indexPath.item])
        
        return cell
    }
    
    
    //셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing = (sectionInset * 2) + (space * (columns - 1))
        let itemWidth = (collectionView.bounds.width - totalSpacing) / columns
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        space
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = MainInfoViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
}
