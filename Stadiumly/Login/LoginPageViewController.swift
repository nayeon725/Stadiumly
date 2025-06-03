//
//  LoginPageViewController.swift
//  Stadiumly
//
//  Created by Hee  on 6/3/25.
//

import UIKit
import SnapKit

//로그인 페이지
class LoginPageViewController: UIViewController {
    
    private var testImageList = ["doosanbears","giants","hanwhaeagles","kiatigers","kiwoom","ktwiz","lgtwins","ncdinos","samsunglions","ssglanders"]
    
    private let stadiumlyLogo = UIImageView()
    private let idTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let findIdButton = UIButton()
    private let findPasswordButton = UIButton()
    private let singUpButton = UIButton()
    private let infoButton = UIButton()
   
    lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
    }

    func setupAddSubview() {
        [stadiumlyLogo, idTextField, passwordTextField, loginButton, findIdButton, findPasswordButton, singUpButton, infoButton, carouselCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        stadiumlyLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.centerX.equalToSuperview()
        }
        carouselCollectionView.snp.makeConstraints {
            $0.top.equalTo(stadiumlyLogo.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(230)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(carouselCollectionView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.equalTo(65)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.equalTo(65)
        }
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.equalTo(65)
        }
        findIdButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(60)
        }
        findPasswordButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(50)
            $0.leading.equalTo(findIdButton.snp.trailing).offset(5)
        }
        singUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(50)
            $0.leading.equalTo(findPasswordButton.snp.trailing).offset(5)
        }
        infoButton.snp.makeConstraints {
            $0.top.equalTo(findPasswordButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(80)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        stadiumlyLogo.image = UIImage(named: "stadiumlyLogo")
        idTextField.placeholder = "아이디 입력"
        passwordTextField.placeholder = "비밀번호 입력"
        textFieldStyle(idTextField)
        textFieldStyle(passwordTextField)
        leftPadding(to: idTextField)
        leftPadding(to: passwordTextField)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .gray
        loginButton.layer.cornerRadius = 20
        loginButton.setTitleColor(.black, for: .normal)
        findIdButton.setTitleColor(.black, for: .normal)
        findIdButton.setTitle("아이디찾기 /", for: .normal)
        findPasswordButton.setTitleColor(.black, for: .normal)
        findPasswordButton.setTitle("비밀번호 찾기 /", for: .normal)
        singUpButton.setTitle("회원가입", for: .normal)
        singUpButton.setTitleColor(.black, for: .normal)
        infoButton.setTitleColor(.black, for: .normal)
        infoButton.setTitle("로그인 없이 이용 하시겠습니까?", for: .normal)
        singUpButton.addTarget(self, action: #selector(signUpMoveVC), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(mainVC), for: .touchUpInside)
    }
    
    func setupProperty() {
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(LoginPageCollectionViewCell.self, forCellWithReuseIdentifier: "loginCell")
    }
   
}
//MARK: - 버튼 함수들 + 화면이동 
extension LoginPageViewController {

    
    private func textFieldStyle(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 20
    }
    
    private func leftPadding(to textField:UITextField, width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: idTextField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @objc private func findIdMoveVC() {
        
    }
    
    @objc private func findPasswordMoveVC() {
        
    }
    
    @objc private func signUpMoveVC() {
        let signUpVC = SignUpPageViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func mainVC() {
        let mainVC = ViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
//MARK: - 컬렉션뷰
extension LoginPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginPageCollectionViewCell.identifier, for: indexPath) as? LoginPageCollectionViewCell
        else { return UICollectionViewCell() }
        let imageName = testImageList[indexPath.row]
        cell.configure(with: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
