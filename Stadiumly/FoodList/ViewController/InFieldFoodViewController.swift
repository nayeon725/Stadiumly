//
//  InFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import UIKit
import SnapKit

//구장 내 먹거리
class InFieldFoodViewController: UIViewController {
    
    var inFieldFoodData: [String]?
    
    private let apiKey = ""
    
    var testImageList = ["doosanbears","giants","hanwhaeagles","kiatigers","kiwoom","ktwiz","lgtwins","ncdinos","samsunglions","ssglanders"]
    
    lazy var inFieldCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
    }
    //addSubView
    func setupAddSubview() {
        [inFieldCollectionView].forEach {
            view.addSubview($0)
        }
    }
    //오토 레이아웃
    func setupConstraints() {
        inFieldCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    //UI 속성
    func configureUI() {
        
    }
    //property
    func setupProperty() {
        inFieldCollectionView.delegate = self
        inFieldCollectionView.dataSource = self
        inFieldCollectionView.register(InFieldCollectionViewCell.self, forCellWithReuseIdentifier: InFieldCollectionViewCell.identifier)
    }
    
    
}
//MARK: - 컬렉션뷰 + 디테일 페이지 이동하기
extension InFieldFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //디테일 페이지 이동부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = testImageList[indexPath.row]
        let detailPageVC = DetailedPageViewController()
        detailPageVC.detailData = selectedItem
        detailPageVC.modalPresentationStyle = .pageSheet
        
        if let modalView = detailPageVC.sheetPresentationController {
            modalView.detents = [.medium()] // 화면 반 정도
            modalView.prefersGrabberVisible = true // 위에 손잡이 표시
            modalView.preferredCornerRadius = 20
           }
           present(detailPageVC, animated: true)
    }

    //만들 셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testImageList.count
    }
    //셀 정의 - 재사용셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InFieldCollectionViewCell.identifier, for: indexPath) as? InFieldCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let imageName = testImageList[indexPath.row]
        cell.configure(with: imageName)
        return cell
    }
    //셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 175)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth: CGFloat = 160 * 2
        let totalSpacing: CGFloat = 40  // 셀 사이 간격
        let availableWidth = collectionView.bounds.width
        let inset = max((availableWidth - totalCellWidth - totalSpacing) / 2, 0)
        
        return UIEdgeInsets(top: 10, left: inset, bottom: 30, right: inset)
    }
    // 셀 세로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
//API 데이터 받는거 > 수정해야함
extension InFieldFoodViewController {
    //수정해야함
    func inFieldFood(longitude: Double, latitude: Double) {
        let endPoint = ""
        guard let url = URL(string: endPoint) else { return }
        var request = URLRequest(url: url)
        request.addValue("\(apiKey)", forHTTPHeaderField: "")
        let seesion = URLSession.shared
        let task = seesion.dataTask(with: request) { data, _ , error in
            if let error = error {
                print("요청 실패 Error: \(error.localizedDescription)")
                return
            }
            guard let data else {
                print("데이터가 없습니다")
                return
            }
            print(String(data: data, encoding: .utf8) ?? "❌문자열 변환 실패")
            do {
                _ = try JSONDecoder().decode(KakaoSearch.self, from: data)
                DispatchQueue.main.async {
                    self.inFieldCollectionView.reloadData()
                }
            } catch {
                print("디코딩 실패\(error)")
            }
        }
        task.resume()
    }
    
}
