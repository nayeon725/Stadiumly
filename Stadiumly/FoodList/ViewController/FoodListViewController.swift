//
//  FoodListViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/22/25.

import UIKit
import SnapKit

//먹거리 페이지
class FoodListViewController: UIViewController {
    

    weak var delegate: FoodSearchDelegate?
    
    private lazy var apiKey: String = {
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["KAKAO_API_KEY_NY"] as? String {
            return key
        }
        return ""
    }()
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    private let xmarkButton = UIButton()
    private let searchBarView = UIView()
    private let foodTitleLabel = UILabel()

    private let foodMenuTitle = ["구장 내 먹거리", "야구선수의메뉴추천", "구장 외 먹거리"]
    private var menuButton: [UIButton] = []
    private let selectorView = UIView()
    private var selectedButtonIndex = 0
    private let segmentBackgroundView = UIView()
    private let buttonStackView = UIStackView()
    let searchBar = UISearchBar()

    private var infieldFoodVC = InFieldFoodViewController()
    private var outfieldFoodVC = OutFieldFoodViewController()
    private var playerRecommedVC = PlayerRecommedViewController()
    private let containerView = UIView()
    private var currentChildVC: UIViewController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStadiumInfo()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
        setupSegement()
        setupViewControllers()
        showChildViewController(infieldFoodVC)
        DispatchQueue.main.async {
            self.updateSelector(animaited: false)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        xmarkButton.addGestureRecognizer(tapGesture)
    }
    private func updateStadiumInfo() {
        if let stadium = DataManager.shared.selectedStadium {
            lat = stadium.latitude
            lon = stadium.longitude
        }
    }
    @objc private func logoTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelector(animaited: true)
    }
    
    func setupAddSubview() {
        [searchBar, foodTitleLabel, segmentBackgroundView, searchBarView, containerView].forEach {
            view.addSubview($0)
        }
        segmentBackgroundView.addSubview(buttonStackView)
        searchBarView.addSubview(searchBar)
    }
    
    func setupConstraints() {
        foodTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(foodTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(foodTitleLabel.snp.bottom).offset(20)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview()
        }
        segmentBackgroundView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(385)
            $0.height.equalTo(50)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        foodTitleLabel.text = "먹거리"
        foodTitleLabel.font = .systemFont(ofSize: 20)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "먹거리를 검색해 주세요"
        searchBar.backgroundColor = .clear
        searchBar.setImage(UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .clear, state: .normal)
        segmentBackgroundView.backgroundColor = .white
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        selectorView.backgroundColor = .black
        segmentBackgroundView.insertSubview(selectorView, at: 0)
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
            textField.layer.cornerRadius = 20
            textField.clipsToBounds = true
            textField.layer.masksToBounds = true
            textField.borderStyle = .none
        }
        
        searchBarView.layer.shadowRadius = 0.5
        searchBarView.layer.shadowOpacity = 0.1
        searchBarView.layer.shadowColor = UIColor.black.cgColor
        
    }
    func setupProperty() {
        searchBar.delegate = self
        self.delegate = outfieldFoodVC
        
    }

}
//MARK: - 푸드 검색 API
extension FoodListViewController {

    func searchFood(query: String?) {
        guard let query else { return }
        let endPoint = "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(query)&category_group_code=FD6&x=\(lon)&y=\(lat)"
        guard let url = URL(string: endPoint) else { return }
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
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
            //            print(String(data: data, encoding: .utf8) ?? "❌문자열 변환 실패")
            do {
                let decoded = try JSONDecoder().decode(KakaoSearch.self, from: data)
                DispatchQueue.main.async {
                    self.delegate?.didReceiveSearchResults(decoded.documents)
                }
            } catch {
                print("디코딩 실패\(error)")
            }
        }
        task.resume()
    }
    
}
//MARK: - 커스텀 세그먼트 함수들
extension FoodListViewController {
    
    private func setupViewControllers() {
        
        infieldFoodVC = InFieldFoodViewController()
        outfieldFoodVC = OutFieldFoodViewController()
        playerRecommedVC = PlayerRecommedViewController()
        
        
        self.delegate = outfieldFoodVC
        
        let viewControllers: [UIViewController] = [infieldFoodVC, outfieldFoodVC, playerRecommedVC]
        
        
        viewControllers.forEach { vc in
            addChild(vc)
            if let vcView = vc.view {
                vcView.frame = containerView.bounds
                vcView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                vcView.isHidden = true
            }
            vc.didMove(toParent: self)
        }
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        let orderControllers: [UIViewController] = [infieldFoodVC, outfieldFoodVC, playerRecommedVC]
        orderControllers.forEach { vc in
            if let vcview = vc.view {
                containerView.addSubview(vcview)
                vcview.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                vcview.isHidden = true
            }
            
        }
    }
    
    func setupSegement() {
        for(index, title) in foodMenuTitle.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.tag = index
            button.addTarget(self, action: #selector(segementTapped(_:)), for: .touchUpInside)
            menuButton.append(button)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    
    func updateSelector(animaited: Bool) {
        
        for (i, btn) in menuButton.enumerated() {
            btn.setTitleColor(i == selectedButtonIndex ? .black : .black , for: .normal)
        }
        
        let selectedButton = menuButton[selectedButtonIndex]
        let underlineHeight: CGFloat = 3
        let selectorFrame = CGRect(x: selectedButton.frame.origin.x, y: selectedButton.frame.maxY-underlineHeight, width: selectedButton.frame.width, height: underlineHeight)
        
        if animaited {
            UIView.animate(withDuration: 0.25) {
                self.selectorView.frame = selectorFrame
            }
        } else {
            self.selectorView.frame = selectorFrame
        }
    }
    
    func showChildViewController(_ vc: UIViewController) {
        
        if let current = currentChildVC {
            current.view.isHidden = true
            current.view.isUserInteractionEnabled = false
        }
        vc.view.isHidden = false
        vc.view.isUserInteractionEnabled = true
        containerView.bringSubviewToFront(vc.view)
        currentChildVC = vc
        
        if vc === outfieldFoodVC {
            self.delegate = outfieldFoodVC
        }
    }
    
    @objc func segementTapped(_ sender: UIButton) {
        selectedButtonIndex = sender.tag
        updateSelector(animaited: true)
        switch sender.tag {
        case 0: showChildViewController(infieldFoodVC)
        case 1: showChildViewController(playerRecommedVC)
        case 2: showChildViewController(outfieldFoodVC)
        default: break
        }
    }
}
//MARK: - 서치바 설정
extension FoodListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if currentChildVC == outfieldFoodVC {
            searchFood(query: searchBar.text)
        }
        searchBar.resignFirstResponder()
    }
}
