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
    
    private var inFieldFoodData: [String]?
    
    
    private let apiKey = ""
    
    var testImageList = ["doosanbears","giants","hanwhaeagles","kiatigers","kiwoom","ktwiz","lgtwins","ncdinos","samsunglions","ssglanders"]
    private let categoryOptions = ["분식", "디저트", "치킨", "패스트푸드", "중식"]
    private var isDropdownVisible = false
    private let foodMenuTitle = ["1루", "3루", "외야"]
    private var dropdownButton = UIButton(type: .system)
    private let dropdownTableView = UITableView()
    
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
        
        DispatchQueue.main.async {
            self.updateSelector(animaited: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelector(animaited: true)
    }
    
    func setupAddSubview() {
        [inFieldCollectionView, segmentBackgroundView, dropdownButton, dropdownTableView].forEach {
            view.addSubview($0)
        }
        segmentBackgroundView.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        segmentBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(dropdownButton.snp.trailing).offset(5)
            $0.width.equalTo(250)
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
        dropdownButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        dropdownTableView.snp.makeConstraints {
            $0.top.equalTo(dropdownButton.snp.bottom)
            $0.centerX.equalTo(dropdownButton.snp.centerX)
            $0.width.equalTo(dropdownButton.snp.width)
            $0.height.equalTo(44 * categoryOptions.count)
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
        
        dropdownTableView.isHidden = true
        dropdownTableView.rowHeight = 44
        dropdownTableView.separatorInset = .zero
        dropdownTableView.layer.cornerRadius = 20
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.layer.borderWidth = 0.5
        
        dropdownButton.setTitle("카테고리", for: .normal)
        dropdownButton.setTitleColor(.black, for: .normal)
        dropdownButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        dropdownButton.tintColor = .black
        dropdownButton.backgroundColor = .lightGray
        dropdownButton.layer.cornerRadius = 24
        dropdownButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
    }
    
    func setupProperty() {
        inFieldCollectionView.delegate = self
        inFieldCollectionView.dataSource = self
        inFieldCollectionView.register(InFieldCollectionViewCell.self, forCellWithReuseIdentifier: InFieldCollectionViewCell.identifier)
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        dropdownTableView.isHidden = !isDropdownVisible
    }
    
}
//MARK: - 커스텀 세그먼트
extension InFieldFoodViewController {
    //세그먼트 버튼,타이틀 함수
    func setupSegement() {
        for(index, title) in foodMenuTitle.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            //선택된 버튼이면 흰색 or 아니면 그레이 텍스트 컬러를 설정
            button.setTitleColor(index == selectedButtonIndex ? .white : .lightGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            //버튼에 태그를 붙여서 어떤게 선택됬나 판단
            button.tag = index
            button.addTarget(self, action: #selector(segementTapped(_:)), for: .touchUpInside)
            //만들어진 버튼을 append
            menuButton.append(button)
            buttonStackView.addArrangedSubview(button)
        }
    }
    //커스텀 세그먼트 애니메이션, 텍스트컬러
    func updateSelector(animaited: Bool) {
        //텍스트 컬러 업데이트
        for (i, btn) in menuButton.enumerated() {
            btn.setTitleColor(i == selectedButtonIndex ? .white : .lightGray , for: .normal)
        }
        
        //selectorView 애니메이션
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
    //세그먼트 텝버튼 함수
    @objc private func segementTapped(_ sender: UIButton) {
        //눌린 버튼의 tag를 selectedButtonIndex에 저장해서 선택상태 갱신하기
        selectedButtonIndex = sender.tag
        updateSelector(animaited: true)
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
        let totalSpacing: CGFloat = 30  // 셀 사이 간격
        let availableWidth = collectionView.bounds.width
        let inset = max((availableWidth - totalCellWidth - totalSpacing) / 2, 0)
        
        return UIEdgeInsets(top: 10, left: inset, bottom: 30, right: inset)
    }
    
    // 셀 세로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
//MARK: - API 데이터 받는거 > 수정해야함
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
//MARK: - 드롭다운메뉴 테이블뷰
extension InFieldFoodViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categoryOptions[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.8
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdownButton.setTitle(categoryOptions[indexPath.row], for: .normal)
        isDropdownVisible = false
        dropdownTableView.isHidden = true
    }
    
}
