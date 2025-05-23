//
//  FoodListViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/22/25.
//

import UIKit
import SnapKit

class FoodListViewController: UIViewController {
    
    let xmarkButton = UIButton()
    let searchBar = UISearchBar()
    let searchBarView = UIView()
    let foodTitleLabel = UILabel()
    //커스텀 button 세그먼트
    let foodMenuTitle = ["구장 내 먹거리", "야구 선수 추천", "구장 외 먹거리"]
    var menuButton: [UIButton] = []
    let selectorView = UIView()
    var selectedButtonIndex = 0
    let segmentBackgroundView = UIView()
    let buttonStackView = UIStackView()
    //하단에 표시할 뷰컨들
    let infieldFoodVC = InFieldFoodViewController()
    let outfieldFoodVC = OutFieldFoodViewController()
    let playerRecommedVC = PlayerRecommedViewController()
    let containerView = UIView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
        setupSegement()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelector(animaited: true)
    }
    //addSubview
    func setupAddSubview() {
        [xmarkButton, searchBar, foodTitleLabel, segmentBackgroundView, searchBarView].forEach {
            view.addSubview($0)
        }
        segmentBackgroundView.addSubview(buttonStackView)
        searchBarView.addSubview(searchBar)
        
    }
    //오토레이아웃
    func setupConstraints() {
        foodTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }
        xmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
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
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(385)
            $0.height.equalTo(50)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    //UI 속성
    func configureUI() {
        view.backgroundColor = .white
        foodTitleLabel.text = "먹거리"
        foodTitleLabel.font = .systemFont(ofSize: 20)
        xmarkButton.setImage(UIImage(named: "xmark"), for: .normal)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "먹거리를 검색해 주세요"
        searchBar.backgroundColor = .clear
        searchBar.setImage(UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .clear, state: .normal)
        segmentBackgroundView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        segmentBackgroundView.layer.cornerRadius = 24
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        selectorView.backgroundColor = UIColor(white: 0.25, alpha: 1)
        selectorView.layer.cornerRadius = 20
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
    //property
    func setupProperty() {
        searchBar.delegate = self
    }
    
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
    
    @objc func segementTapped(_ sender: UIButton) {
        selectedButtonIndex = sender.tag
        updateSelector(animaited: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FoodListViewController: UISearchBarDelegate {
    
}
