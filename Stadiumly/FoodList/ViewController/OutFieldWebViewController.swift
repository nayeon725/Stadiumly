//
//  OutFieldWebViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/27/25.
//

import UIKit
import WebKit

class OutFieldWebViewController: UIViewController {

    var urlString: String?
    let xmarkButton = UIButton()
    let webVeiw = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //addSubView
    func setupAddSubview() {
        [webVeiw, xmarkButton].forEach {
            view.addSubview($0)
        }
    }
    //오토 레이아웃
    func setupConstraints() {
        webVeiw.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
