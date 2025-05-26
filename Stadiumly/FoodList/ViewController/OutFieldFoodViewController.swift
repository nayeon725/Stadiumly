//
//  OutFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import UIKit
import SnapKit
import MapKit

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
            $0.verticalEdges.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    //UI 속성
    func configureUI() {
        
    }
    //property
    func setupProperty() {
    
    }

}
