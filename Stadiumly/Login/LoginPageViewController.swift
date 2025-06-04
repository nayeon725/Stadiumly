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
    
    private var mascotImageList = ["mascot_doosanbears","mascot_hanhwaeagles","mascot_kiatigers","mascot_kiwoomheroes","mascot_ktwiz","mascot_lgtwins","mascot_lottegiants","mascot_ncdinos","mascot_samsunglions","mascot_ssglanders"]
    
    private var timer: Timer?
    
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
        setupMascot()
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
            $0.top.equalTo(carouselCollectionView.snp.bottom).offset(30)
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
        self.navigationItem.hidesBackButton = true
    }
    
    func setupProperty() {
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(LoginPageCollectionViewCell.self, forCellWithReuseIdentifier: "loginCell")
        idTextField.delegate = self
        passwordTextField.delegate = self
        
    }
   
}
//MARK: - 화면이동, 텍스트필드
extension LoginPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func leftPadding(to textField:UITextField, width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: idTextField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 20
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
//MARK: - 캐러셀 설정
extension LoginPageViewController {

    private func setupMascot() {
        // 초기 위치 설정
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let middleIndex = self.mascotImageList.count * 100
            self.carouselCollectionView.scrollToItem(at: IndexPath(item: middleIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.startAutoScroll()
        }
    }
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
        guard let currentIndexPath = carouselCollectionView.indexPathsForVisibleItems.first else { return }
        let nextItem = currentIndexPath.item + 1
        let nextIndexPath = IndexPath(item: nextItem, section: 0)
        
        carouselCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
}
//MARK: - 컬렉션뷰
extension LoginPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mascotImageList.count * 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginPageCollectionViewCell.identifier, for: indexPath) as? LoginPageCollectionViewCell
        else { return UICollectionViewCell() }
        let imageIndex = indexPath.item % mascotImageList.count
        cell.configure(with: mascotImageList[imageIndex])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let nextVC = FoodListViewController()
//            navigationController?.pushViewController(nextVC, animated: true)
//            print(indexPath.item)
//    }
//    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let imageCount = mascotImageList.count
        
        // 경계에 도달했을 때 중간으로 이동
        if currentIndex < imageCount || currentIndex > (mascotImageList.count * 200) - imageCount {
            let middleIndex = mascotImageList.count * 100
            let newIndex = middleIndex + (currentIndex % imageCount)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newIndex) * scrollView.bounds.width, y: 0), animated: false)
        }
    }
    
}

