//
//  OutFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import KakaoMapsSDK
import SnapKit
import UIKit

//검색결과 전달 프로토콜
protocol FoodSearchDelegate: AnyObject {
    func didReceiveSearchResults(_ places: [Place])
}
//구장 외 먹거리
class OutFieldFoodViewController: UIViewController {
    
    
    let outFieldMapView = MKMapView()
//    var mapView: MTMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
        setupMapProperty()
        addViews()
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    //스토리보드 안쓸경우 처리
    required init?(coder: NSCoder) {
        fatalError("Storyboard를 사용하지 않음!")
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    //addSubView
    func setupAddSubview() {
        [outFieldMapView].forEach {
            view.addSubview($0)
        }
    }
    //오토 레이아웃
    func setupConstraints() {
        outFieldMapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    //UI 속성
    func configureUI() {
    }
    //property
    func setupProperty() {
    
    }

}
