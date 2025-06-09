//
//  ViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/21/25.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let space: CGFloat = 10
    private let columns: CGFloat = 2
    private let sectionInset: CGFloat = 10
    
    private var stadiums: [Stadium] = []
    
    private var imageURL: String = ""
    
    private let titleImage: UIImageView = {
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        findStadium()
        
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
    
    private func findStadium() {
        let endPt = "http://localhost:3000/stadium"
        guard let url = URL(string: endPt) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")  // 200 OK인지 확인
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            print("받은 데이터 크기: \(data.count)")

            do {
                let stadiums = try JSONDecoder().decode([Stadium].self, from: data)
                print("디코딩 성공: \(stadiums.count)개")
                DispatchQueue.main.async {
                    self.stadiums = stadiums
                    DataManager.shared.setStadiums(self.stadiums)
                    self.collectionView.reloadData()
                }
            } catch {
                print("디코딩 에러: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("받은 JSON 문자열: \(jsonString)")
                } else {
                    print("JSON 문자열 변환 실패")
                }
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stadiums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StadiumCollectionCell.identifier, for: indexPath) as! StadiumCollectionCell
        let stadium = stadiums[indexPath.item]
        if let url = URL(string: stadium.image) {
            cell.stadiumImageView.kf.setImage(with: url)
        } else {
            cell.stadiumImageView.image = UIImage(named: "placeholder")
        }
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
        let selectedStadium = stadiums[indexPath.item]
        DataManager.shared.setSelectedStadium(selectedStadium)
        
        let mainInfoVC = MainInfoViewController()
        navigationController?.pushViewController(mainInfoVC, animated: true)
    }
}

