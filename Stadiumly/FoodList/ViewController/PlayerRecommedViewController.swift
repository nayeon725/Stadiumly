//
//  PlayerRecommedViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import UIKit
import SnapKit
import Alamofire


//야구 선수 추천
class PlayerRecommedViewController: UIViewController {
    
    
    
    private var stadiumlyId: Int = 0
    
    private var playerRecommand: [PlayerRecommand] = []
    
    lazy var playerRecommedCollectionView: UICollectionView = {
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
    
    }
    
    private func updateStadiumInfo() {
        if let stadium = DataManager.shared.selectedStadium {
            stadiumlyId = stadium.id
            playerRecommed(stadiumlyId: String(stadiumlyId))
        } else {
            print("❌ selectedStadium이 nil입니다")
        }
    }

    func setupAddSubview() {
        [playerRecommedCollectionView].forEach {
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        playerRecommedCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureUI() {
        
    }

    func setupProperty() {
        playerRecommedCollectionView.delegate = self
        playerRecommedCollectionView.dataSource = self
        playerRecommedCollectionView.register(PlayerRecommedCollectionViewCell.self, forCellWithReuseIdentifier: PlayerRecommedCollectionViewCell.identifier)
    }

}
//MARK: - 컬렉션뷰 + 디테일 페이지 이동하기
extension PlayerRecommedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = playerRecommand[indexPath.row]
        let detailPageVC = DetailedPlayerViewController()
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
        return playerRecommand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerRecommedCollectionViewCell.identifier, for: indexPath) as? PlayerRecommedCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configureImage(with: playerRecommand[indexPath.row])
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 175)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth: CGFloat = 160 * 2
        let totalSpacing: CGFloat = 30  // 셀 사이 간격
        let availableWidth = collectionView.bounds.width
        let inset = max((availableWidth - totalCellWidth - totalSpacing) / 2, 0)
        
        return UIEdgeInsets(top: 10, left: inset, bottom: 30, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
}
//MARK: - API
extension PlayerRecommedViewController {

    func playerRecommed(stadiumlyId: String) {
        let endPt = "http://20.41.113.4/player-recommand/\(String(stadiumlyId))"
        AF.request(endPt, method: .get)
            .validate()
            .responseDecodable(of: [PlayerRecommand].self) { response in
                switch response.result {
                case.success(let decoded):
                    DispatchQueue.main.async {
                        self.playerRecommand = decoded
                        self.playerRecommedCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("요청실패\(error.localizedDescription)")

                }
                if let data = response.data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("받은 응답 JSON: \(jsonString)")
            }
        }
    }
}
