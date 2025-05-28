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
    
    let clubImages = ["kiwoom", "ssglanders", "giants", "ktwiz", "samsunglions", "ncdinos", "doosanbears", "lgtwins", "kiatigers", "hanwhaeagles" ]
    
    var stadiums: [Stadium] = []
    var sta_lat: Double = 0.0
    var sta_lon: Double = 0.0
    var sta_name: String = ""
    
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
    
    func findStadium() {
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
        print(indexPath.item)
        
        switch indexPath.item {
        case 0:
            nextVC.stadiumName = stadiums[0].name
            nextVC.lat = stadiums[0].latitude
            nextVC.lon = stadiums[0].longitude
            nextVC.teamName = stadiums[0].team
        case 1:
            nextVC.stadiumName = stadiums[1].name
            nextVC.lat = stadiums[1].latitude
            nextVC.lon = stadiums[1].longitude
            nextVC.teamName = stadiums[1].team
        case 2:
            nextVC.stadiumName = stadiums[2].name
            nextVC.lat = stadiums[2].latitude
            nextVC.lon = stadiums[2].longitude
            nextVC.teamName = stadiums[2].team
        case 3:
            nextVC.stadiumName = stadiums[3].name
            nextVC.lat = stadiums[3].latitude
            nextVC.lon = stadiums[3].longitude
            nextVC.teamName = stadiums[3].team
        case 4:
            nextVC.stadiumName = stadiums[4].name
            nextVC.lat = stadiums[4].latitude
            nextVC.lon = stadiums[4].longitude
            nextVC.teamName = stadiums[4].team
        case 5:
            nextVC.stadiumName = stadiums[5].name
            nextVC.lat = stadiums[5].latitude
            nextVC.lon = stadiums[5].longitude
            nextVC.teamName = stadiums[5].team
        case 6:
            nextVC.stadiumName = stadiums[6].name
            nextVC.lat = stadiums[6].latitude
            nextVC.lon = stadiums[6].longitude
            nextVC.teamName = stadiums[6].team
        case 7:
            nextVC.stadiumName = stadiums[7].name
            nextVC.lat = stadiums[7].latitude
            nextVC.lon = stadiums[7].longitude
            nextVC.teamName = stadiums[7].team
        case 8:
            nextVC.stadiumName = stadiums[8].name
            nextVC.lat = stadiums[8].latitude
            nextVC.lon = stadiums[8].longitude
            nextVC.teamName = stadiums[8].team
        case 9:
            nextVC.stadiumName = stadiums[9].name
            nextVC.lat = stadiums[9].latitude
            nextVC.lon = stadiums[9].longitude
            nextVC.teamName = stadiums[9].team
        default:
            break
        }
    }
}
