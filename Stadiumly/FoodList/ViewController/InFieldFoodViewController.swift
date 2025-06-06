//
//  InFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import UIKit
import SnapKit

struct Cafeteria: Codable {
    let cafe_name: String
    let cafe_image: String
    let cafe_location: String
}

//구장 내 먹거리
class InFieldFoodViewController: UIViewController {
    
    private var stadiumlyId: Int = 0
    
    private var cafeteriaList: [Cafeteria] = []
    
    
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
        updateStadiumInfo()
        playerRecommed()
        
    }
    private func updateStadiumInfo() {
        if let stadium = DataManager.shared.selectedStadium {
            stadiumlyId = stadium.id

        }
    }
    
    func setupAddSubview() {
        view.addSubview(inFieldCollectionView)
    }
    
    func setupConstraints() {
        inFieldCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
    }
    
    func setupProperty() {
        inFieldCollectionView.delegate = self
        inFieldCollectionView.dataSource = self
        inFieldCollectionView.register(InFieldCollectionViewCell.self, forCellWithReuseIdentifier: InFieldCollectionViewCell.identifier)
    }
    
}
//MARK: - 컬렉션뷰 + 디테일 페이지 이동하기
extension InFieldFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = cafeteriaList[indexPath.row]
        let detailPageVC = DetailedInFieldViewController()
        detailPageVC.detailData = selectedItem
        detailPageVC.modalPresentationStyle = .pageSheet
        
        if let modalView = detailPageVC.sheetPresentationController {
            modalView.detents = [.medium()]
            modalView.prefersGrabberVisible = true 
            modalView.preferredCornerRadius = 20
        }
        present(detailPageVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cafeteriaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InFieldCollectionViewCell.identifier, for: indexPath) as? InFieldCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configureImage(with: cafeteriaList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth: CGFloat = 160 * 2
        let totalSpacing: CGFloat = 30  
        let availableWidth = collectionView.bounds.width
        let inset = max((availableWidth - totalCellWidth - totalSpacing) / 2, 0)
        
        return UIEdgeInsets(top: 10, left: inset, bottom: 30, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

//MARK: - API
extension InFieldFoodViewController {
 
    func playerRecommed() {
        let endPt = "http://20.41.113.4/cafeteria/\(String(stadiumlyId))?location=3ru_3f"
        guard let url = URL(string: endPt) else { return }
        let request = URLRequest(url: url)
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
                let decoded = try JSONDecoder().decode([Cafeteria].self, from: data)
                DispatchQueue.main.async {
                    self.cafeteriaList = decoded
                    self.inFieldCollectionView.reloadData()
                }
            } catch {
                print("디코딩 실패\(error)")
            }
        }
        task.resume()
    }
}
