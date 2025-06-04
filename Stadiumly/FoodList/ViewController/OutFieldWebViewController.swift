//
//  OutFieldWebViewController.swift
//  Stadiumly
//

import UIKit
import SnapKit
import WebKit

//구장 외 먹거리 웹뷰
class OutFieldWebViewController: UIViewController {

    var urlString: String?
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
        guard let urlString,
              let url = URL(string: urlString)
        else { return }
        let request = URLRequest(url: url)
        webVeiw.load(request)
        
    }

}
