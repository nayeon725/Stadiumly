//
//  InFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import UIKit
import SnapKit
import Alamofire



//구장 내 먹거리
class InFieldFoodViewController: UIViewController {
    
    private var stadiumlyId: Int = 0
    
    private var cafeteriaList: [Cafeteria] = []
    
    private var filteredList: [Cafeteria] = []
    private var isSearching: Bool = false
    

    private let foodMenuTitle = ["1루", "3루", "외야"]
    private let foodMenuCodes = ["1ru", "3ru", "outside"] //서버요청용

    
    private var menuButton: [UIButton] = []
    private let selectorView = UIView()
    private var selectedButtonIndex = 0
    private let segmentBackgroundView = UIView()
    private let buttonStackView = UIStackView()
    
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
        setupSegement()
        updateStadiumInfo()

        let defaultLocation = foodMenuCodes[1]
        inFieldFoodList(location: defaultLocation)
        
        DispatchQueue.main.async {
            self.updateSelector(animaited: false)
        }
    }
    private func updateStadiumInfo() {
        if let stadium = DataManager.shared.selectedStadium {
            stadiumlyId = stadium.id

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelector(animaited: true)
    }
    
    func setupAddSubview() {
        [inFieldCollectionView, segmentBackgroundView].forEach {
            view.addSubview($0)
        }
        segmentBackgroundView.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        segmentBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
        }
        buttonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        inFieldCollectionView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(0)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        segmentBackgroundView.addSubview(buttonStackView)
        segmentBackgroundView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        segmentBackgroundView.layer.cornerRadius = 24
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        selectorView.backgroundColor = UIColor(white: 0.25, alpha: 1)
        selectorView.layer.cornerRadius = 20
        segmentBackgroundView.insertSubview(selectorView, at: 0)

    }
    
    func setupProperty() {
        inFieldCollectionView.delegate = self
        inFieldCollectionView.dataSource = self
        inFieldCollectionView.register(InFieldCollectionViewCell.self, forCellWithReuseIdentifier: InFieldCollectionViewCell.identifier)
    }
    
}
//MARK: - 커스텀 세그먼트
extension InFieldFoodViewController {
    
    func setupSegement() {
        for(index, title) in foodMenuTitle.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(index == selectedButtonIndex ? .white : .lightGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.tag = index
            button.addTarget(self, action: #selector(segementTapped(_:)), for: .touchUpInside)
          
            menuButton.append(button)
            buttonStackView.addArrangedSubview(button)
        }
    }
    func updateSelector(animaited: Bool) {
    
        for (i, btn) in menuButton.enumerated() {
            btn.setTitleColor(i == selectedButtonIndex ? .white : .lightGray , for: .normal)
        }
        
        let selectedButton = menuButton[selectedButtonIndex]
        let selectorFrame = selectedButton.frame.insetBy(dx: 4, dy: 6)
        
        if animaited {
            UIView.animate(withDuration: 0.25) {
                self.selectorView.frame = selectorFrame
            }
        } else {
            self.selectorView.frame = selectorFrame
        }
    }

    @objc private func segementTapped(_ sender: UIButton) {
        selectedButtonIndex = sender.tag
        updateSelector(animaited: true)
        
        //서버에 층수로 보낼 코드
        let selectedCode = foodMenuCodes[selectedButtonIndex]
        inFieldFoodList(location: selectedCode)
    }
    
}
//MARK: - 컬렉션뷰 + 디테일 페이지 이동하기
extension InFieldFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = isSearching ? filteredList[indexPath.row] : cafeteriaList[indexPath.row]
        let locationStr = convertLocation(baseCode: selectedItem.cafe_location, floor: selectedItem.cafe_floor)
        let detailPageVC = DetailedInFieldViewController()
        detailPageVC.convertedLocation = locationStr
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
        return isSearching ? filteredList.count : cafeteriaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InFieldCollectionViewCell.identifier, for: indexPath) as? InFieldCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let data = isSearching ? filteredList[indexPath.row] : cafeteriaList[indexPath.row]
        cell.configureImage(with: data)
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
 
  
    func convertLocation(baseCode: String, floor: Int?) -> String {
        let baseMapping: [String: String] = ["1ru": "1루", "2ru": "2루", "3ru": "3루", "outside": "외야"]
        let baseKR = baseMapping[baseCode] ?? baseCode
        if let floor = floor {
            return "\(baseKR) \(floor)층"
        } else {
            return baseKR
        }
    }
    
    func inFieldFoodList(location: String) {
        let endPt = "http://20.41.113.4/cafeteria/\(String(stadiumlyId))?location=\(location)"
        AF.request(endPt, method: .get)
            .validate()
            .responseDecodable(of: [Cafeteria].self) { response in
                switch response.result {
                case.success(let decoded):
                    DispatchQueue.main.async {
                        self.cafeteriaList = decoded
                        self.inFieldCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("요청실패\(error.localizedDescription)")
                }
                if let data = response.data,
                   let jsonString = String(data: data, encoding: .utf8) {
//                    print("받은 응답 JSON: \(jsonString)")
            }
        }
    }
}
extension InFieldFoodViewController: FoodCategorySearch {
    
    func filterCafeteria(by category: String?) {
        guard let category = category, !category.isEmpty else {
            isSearching = false
            inFieldCollectionView.reloadData()
            return
        }
        isSearching = true
        filteredList = cafeteriaList.filter {
            $0.cafe_category.localizedStandardContains(category)
        }
        inFieldCollectionView.reloadData()
    }
    
}
