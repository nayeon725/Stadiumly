//
//  OutFieldWebViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/27/25.
//

import UIKit
import SnapKit
import WebKit

class ParkingWebViewController: UIViewController {

    var parkingurlString: String?
    private let webVeiw = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        urlstrRequest()
    
    }
    //addSubView
    func setupAddSubview() {
        [webVeiw].forEach {
            view.addSubview($0)
        }
    }
    //오토 레이아웃
    func setupConstraints() {
        webVeiw.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    //UI 속성
    func configureUI() {
        view.backgroundColor = .white
    }
    func urlstrRequest() {
        guard let parkingurlString,
              let url = URL(string: parkingurlString)
        else { return }
        let request = URLRequest(url: url)
        webVeiw.load(request)
        
    }

}
