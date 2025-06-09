//
//  SingUpPageViewController.swift
//  Stadiumly
//
//  Created by Hee  on 6/2/25.
//

import UIKit
import SnapKit
import Alamofire


//델리게이트로 팀 이름 넘기는 부분
protocol TeamSelectionDelete: AnyObject {
    func didSelectTeam(team: String)
}

//회원가입 페이지
class SignUpPageViewController: UIViewController {
    
    // api 관련
    private let endpt = "http://20.41.113.4/"
    private var userEmail: String = ""
    private var userID: String = ""
    private var userPW: String = ""
    private var userNick: String = ""
    private var userTeam: Int?
    
    private var isEmailUniqueConfirmed = false
    private var isEmailTokenConfirmed = false
    
    weak var delegate: TeamSelectionDelete?
    
    private let idLabel = UILabel()
    private let idTextField = UITextField()
    
    private let nickNameLabel = UILabel()
    private let nickNameTextField = UITextField()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    
    private let verificationLabel = UILabel()
    private let verificationTextField = UITextField()
    private let verificationButton = UIButton()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordInfoLabel = UILabel()
    
    private let cheeringTeamLabel = UILabel()
    private let checkAvailabilityButton = UIButton()
    private let gettingNumberButton = UIButton()
    private let termsofServiceLabel = UILabel()
    private let termsofAgreedLabel = UILabel()
    private let checkBoxButton = UIButton()
    
    private var eyeButton = UIButton(type: .custom)
    
    private let dropdownButton = UIButton(type: .custom)
    private let dropdownTableView = UITableView()
    private let teamOptions = ["기아 타이거즈", "두산 베어스", "롯데 자이언츠", "삼성 라이언즈", "SSG 랜더스", "엘지 트윈스", "NC 다이노스", "키움 히어로즈", "KG 위즈", "한화 이글스", "응원하는팀 없음"]
    private var isDropdownVisible = false
    private let signUpButton = UIButton()
    
    private let contentScrollView = UIScrollView()
    private let contentView = UIView()
    
    //제약조건 변수
    private var passwordLabelTopConstraint: Constraint?
    private var passwordTextFieldTopConstraint: Constraint?
    private var passwordInfoLabelTopConstraint: Constraint?
    private var cheeringTeamLabelTopConstraint: Constraint?
    private var dropdownButtonTopConstraint: Constraint?
    private var dropdownTableViewTopConstraint: Constraint?
    private var termsofServiceLabelTopConstraint: Constraint?
    private var checkBoxButtonTopConstraint: Constraint?
    private var termsofAgreedLabelTopConstraint: Constraint?
    private var signUpButtonTopConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func setupAddSubview() {
        [contentScrollView,].forEach {
            view.addSubview($0)
        }
        contentScrollView.addSubview(contentView)
        [dropdownTableView, idLabel, idTextField, nickNameLabel, nickNameTextField, emailLabel, emailTextField, passwordLabel, passwordTextField, passwordInfoLabel, cheeringTeamLabel
         , dropdownButton, checkAvailabilityButton, gettingNumberButton, termsofServiceLabel,termsofAgreedLabel, checkBoxButton, signUpButton, verificationLabel, verificationTextField, verificationButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        contentScrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(contentScrollView.contentLayoutGuide)
            $0.width.equalTo(contentScrollView.frameLayoutGuide)
            $0.bottom.equalTo(signUpButton.snp.bottom).offset(300)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(25)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        checkAvailabilityButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalTo(idTextField.snp.trailing).offset(10)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(320)
            $0.height.equalTo(50)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        gettingNumberButton.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(40)
            $0.leading.equalTo(emailTextField.snp.trailing).offset(10)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        verificationTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        verificationButton.snp.makeConstraints {
            $0.top.equalTo(gettingNumberButton.snp.bottom).offset(10)
            $0.leading.equalTo(verificationTextField.snp.trailing).offset(10)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        verificationLabel.snp.makeConstraints {
            $0.top.equalTo(verificationTextField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(25)
        }
        passwordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            passwordLabelTopConstraint = $0.top.equalTo(emailTextField.snp.bottom).offset(10).constraint
        }
        passwordTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(320)
            $0.height.equalTo(50)
            passwordTextFieldTopConstraint = $0.top.equalTo(passwordLabel.snp.bottom).offset(5).constraint
        }
        passwordInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            passwordInfoLabelTopConstraint = $0.top.equalTo(passwordTextField.snp.bottom).offset(5).constraint
        }
        
        cheeringTeamLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            cheeringTeamLabelTopConstraint = $0.top.equalTo(passwordInfoLabel.snp.bottom).offset(50).constraint
        }
        dropdownButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(300)
            $0.height.equalTo(50)
            dropdownButtonTopConstraint = $0.top.equalTo(cheeringTeamLabel.snp.bottom).offset(5).constraint
        }
        dropdownTableView.snp.makeConstraints {
            $0.centerX.equalTo(dropdownButton.snp.centerX)
            $0.width.equalTo(dropdownButton.snp.width)
            $0.height.equalTo(44 * teamOptions.count)
            dropdownTableViewTopConstraint = $0.top.equalTo(dropdownButton.snp.bottom).constraint
        }
        termsofServiceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            termsofServiceLabelTopConstraint = $0.top.equalTo(dropdownButton.snp.bottom).offset(50).constraint
        }
        checkBoxButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.width.height.equalTo(30)
            checkBoxButtonTopConstraint = $0.top.equalTo(termsofServiceLabel.snp.bottom).offset(5).constraint
        }
        termsofAgreedLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(5)
            termsofAgreedLabelTopConstraint = $0.top.equalTo(dropdownButton.snp.bottom).offset(82).constraint
        }
        signUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(320)
            $0.height.equalTo(65)
            signUpButtonTopConstraint = $0.top.equalTo(termsofAgreedLabel.snp.bottom).offset(15).constraint
        }
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureLabel(idLabel, text: "아이디", fontSize: 20)
        configureLabel(nickNameLabel, text: "닉네임", fontSize: 20)
        configureLabel(emailLabel, text: "이메일 입력", fontSize: 20)
        configureLabel(passwordLabel, text: "비밀번호", fontSize: 20)
        configureLabel(passwordInfoLabel, text: "영문, 숫자, 특수문자 중 2가지 이상 조합하여 8~16자", fontSize: 16)
        configureLabel(cheeringTeamLabel, text: "응원하는 팀이 있으신가요?", fontSize: 20)
        configureLabel(termsofServiceLabel, text: "이용약관", fontSize: 20)
        configureLabel(termsofAgreedLabel, text: "[필수] 서비스이용약관에 동의합니다.", fontSize: 20)
        configureLabel(verificationLabel, text: "이메일로 발송된 인증번호를 입력해주세요.", fontSize: 16)

        nickNameTextField.placeholder = "닉네임 입력"
        idTextField.placeholder = "아이디 입력"
        emailTextField.placeholder = "이메일 입력"
        passwordTextField.placeholder = "비밀번호 입력"
        verificationTextField.placeholder = "인증번호"
        contentScrollView.backgroundColor = .white
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.contentInsetAdjustmentBehavior = .always
        contentScrollView.isScrollEnabled = true

        let textFields = [idTextField, nickNameTextField, emailTextField, passwordTextField, verificationTextField]
        textFields.forEach { configureTextField(to: $0) }
        
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderColor = UIColor.black.cgColor
        dropdownTableView.layer.borderWidth = 0.5
        dropdownTableView.rowHeight = 44
        dropdownTableView.separatorInset = .zero
        dropdownTableView.backgroundColor = .white
        dropdownTableView.isOpaque = true
        dropdownTableView.tableFooterView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = titleLabel
        verificationLabel.isHidden = true
        verificationTextField.isHidden = true
        verificationButton.isHidden = true
        passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        nickNameTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        verificationTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        checkBoxButton.addTarget(self, action: #selector(termsPageMove), for: .touchUpInside)
        
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
        buttonTypes()
        setPasswordShow()
    }
    
    @objc private func textFieldsDidChange(_ textField: UITextField) {
        if textField == idTextField {
            if let id = textField.text {
                if isValidId(id) {
                    textField.layer.borderColor = UIColor.systemGreen.cgColor
                } else {
                    textField.layer.borderColor = UIColor.systemRed.cgColor
                }
                textField.layer.borderWidth = 0.8
            }
        }
        
        if textField == passwordTextField {
            if let password = textField.text {
                if isValidPassword(password) {
                    textField.layer.borderColor = UIColor.systemGreen.cgColor
                } else {
                    textField.layer.borderColor = UIColor.systemRed.cgColor
                }
                textField.layer.borderWidth = 0.8
            }
        }
        updateSignUpButtonState()
    }
   
    
    private func updateSignUpButtonState() {
        let isAllFilled = !(nickNameTextField.text?.isEmpty ?? true) &&
                          !(emailTextField.text?.isEmpty ?? true) &&
                          !(passwordTextField.text?.isEmpty ?? true) &&
                          !(idTextField.text?.isEmpty ?? true) &&
                          !(verificationTextField.text?.isEmpty ?? true)

        let shouldEnable = isAllFilled && checkBoxButton.isSelected
        signUpButton.isEnabled = shouldEnable
        signUpButton.alpha = shouldEnable ? 1.0 : 0.5
    }
    
    @objc private func checkEmailUniqueButtonTapped() {
        checkEmailUnique(email: emailTextField.text ?? "") { result in
            switch result {
            case .success(let response):
                if response.status == "success" {
                    self.isEmailUniqueConfirmed = true
                    print("✅ 이메일 중복 아님")
                    self.showAlert(title: "중복 이메일 확인", message: "사용 가능한 이메일입니다.")
                } else {
                    self.isEmailUniqueConfirmed = false
                    print("❌ 중복된 이메일")
                    self.showAlert(title: "중복된 이메일", message: "이미 사용 중인 이메일입니다.")
                }
            case .failure:
                self.isEmailUniqueConfirmed = false
                print("❌ 네트워크 오류 등")
                self.showAlert(title: "에러 발생", message: "네트워크 오류가 발생했습니다.")
            }
        }
    }

    @objc private func checkEmailTokenButtonTapped() {
        checkEmailToken(email: emailTextField.text ?? "", token: verificationTextField.text ?? "") { result in
            switch result {
            case .success(let response):
                if response.status == "success" {
                    self.isEmailTokenConfirmed = true
                    print("✅ 인증번호 일치")
                    self.showAlert(title: "인증번호 확인", message: "인증이 완료되었습니다.")
                } else {
                    self.isEmailTokenConfirmed = false
                    print("❌ 인증번호 불일치")
                    self.showAlert(title: "인증 실패", message: "인증번호가 올바르지 않습니다.")
                }
            case .failure:
                self.isEmailTokenConfirmed = false
                print("❌ 네트워크 오류 등")
                self.showAlert(title: "에러 발생", message: "네트워크 오류가 발생했습니다.")
            }
        }
    }

    @objc private func signUpButtonTapped() {
        guard isEmailUniqueConfirmed else {
            showAlert(title: "이메일 확인 필요", message: "이메일 중복 확인을 먼저 진행해주세요.")
            return
        }
        
        guard isEmailTokenConfirmed else {
            showAlert(title: "인증 필요", message: "이메일로 받은 인증번호를 확인해주세요.")
            return
        }
        
        // 최종 가입 요청
        signUpRequest(email: userEmail, id: userID, password: userPW, nick: userNick, team: userTeam) { result in
            switch result {
            case .success(let response):
                self.showAlert(title: "회원가입 완료", message: response.message)
            case .failure(let error):
                self.showAlert(title: "회원가입 실패", message: error.localizedDescription)
            }
        }
    }
    
    private func setupProperty() {
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        passwordTextField.delegate = self
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=(?:.*[A-Za-z].*[0-9]|.*[A-Za-z].*[^A-Za-z0-9]|.*[0-9].*[^A-Za-z0-9]))[A-Za-z0-9!@#$%^&*(),.?\":{}|<>]{8,16}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    

    func isValidId(_ id: String) -> Bool {
        let idRegEx = "^[A-Za-z0-9]{4,12}$"

        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: id)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}

//MARK: - UI 설정 함수들
extension SignUpPageViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureLabel(_ label: UILabel, text: String, fontSize: CGFloat) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = .black
    }
    private func configureTextField(to textField:UITextField, width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: idTextField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 20
    }
    private func configureButton(_ button: UIButton, title: String, titleColor: UIColor, bgColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private func setPasswordShow() {
        eyeButton = UIButton.init(primaryAction: UIAction(handler: { [self]_ in
            passwordTextField.isSecureTextEntry.toggle()
            self.eyeButton.isSelected.toggle()
        }))
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.tintColor = .black
        eyeButton.configuration = buttonConfiguration
        eyeButton.tintColor = .black
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }

    private func buttonTypes(){
        dropdownButton.backgroundColor = .white
        dropdownButton.layer.borderColor = UIColor.black.cgColor
        dropdownButton.layer.borderWidth = 1
        dropdownButton.setTitle("응원하는 팀은?", for: .normal)
        dropdownButton.setTitleColor(.black, for: .normal)
        dropdownButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        dropdownButton.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        dropdownButton.tintColor = .black
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.setTitleColor(.black, for: .highlighted)
        dropdownButton.imageView?.contentMode = .scaleAspectFit
        dropdownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dropdownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 260, bottom: 0, right: 0)
        dropdownButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        
        
        configureButton(checkAvailabilityButton, title: "중복확인", titleColor: .black, bgColor: .gray)
        configureButton(gettingNumberButton, title: "이메일중복확인", titleColor: .black, bgColor: .gray)
        configureButton(verificationButton, title: "인증확인", titleColor: .black, bgColor: .gray)
        configureButton(signUpButton, title: "회원가입", titleColor: .black, bgColor: .gray)
        
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: config)
        checkBoxButton.backgroundColor = .lightGray
        checkBoxButton.setImage(nil, for: .normal)
        checkBoxButton.setImage(checkImage, for: .selected)
        checkBoxButton.tintColor = .black
        checkBoxButton.imageView?.contentMode = .scaleAspectFit
        checkBoxButton.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(moveToSingUpPageVC), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
        let backImage = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(customBackButton))
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .black
        gettingNumberButton.addTarget(self, action: #selector(showVerificationFields), for: .touchUpInside)
        checkAvailabilityButton.addTarget(self, action: #selector(didTapCheckId), for: .touchUpInside)
    }
    
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        dropdownTableView.isHidden = !isDropdownVisible
        contentView.bringSubviewToFront(dropdownTableView)
    }
    
    @objc private func toggleCheck() {
        checkBoxButton.isSelected.toggle()
        updateSignUpButtonState()
    }
    
    @objc private func moveToSingUpPageVC() {
        let singUpVC = SignUpCompletionViewController()
        navigationController?.pushViewController(singUpVC, animated: true)
    }
    
    @objc private func customBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showVerificationFields() {
        verificationLabel.isHidden = false
        verificationTextField.isHidden = false
        verificationButton.isHidden = false
        let offsetAmount: CGFloat = 70
        UIView.animate(withDuration: 0.3) {
            self.passwordLabelTopConstraint?.update(offset: self.verificationTextField.frame.height + 40)
            self.passwordTextFieldTopConstraint?.update(offset: 5)
            self.passwordInfoLabelTopConstraint?.update(offset: 5)
            self.cheeringTeamLabelTopConstraint?.update(offset: 50)
            self.dropdownButtonTopConstraint?.update(offset: 5)
            self.dropdownTableViewTopConstraint?.update(offset: 0)
            self.termsofServiceLabelTopConstraint?.update(offset: 50)
            self.checkBoxButtonTopConstraint?.update(offset: 5)
            self.termsofAgreedLabelTopConstraint?.update(offset: 82)
            self.signUpButtonTopConstraint?.update(offset: 15)
            
            self.view.layoutIfNeeded()
        }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        
        if isValidEmail(email) {
            emailTextField.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            emailTextField.layer.borderColor = UIColor.systemRed.cgColor
        }
        emailTextField.layer.borderWidth = 0.8
    }

    @objc private func termsPageMove() {
        let termsVC = TermsOfServiceViewController()
        present(termsVC, animated: true)
    }
    @objc private func didTapCheckId() {
        userIdUniqueCheck()
    }

}

//MARK: - 테이블뷰
extension SignUpPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = teamOptions[indexPath.row]
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        cell.textLabel?.backgroundColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //델리게이트로 데이터 넘기는 부분
        let selectedTeam = teamOptions[indexPath.row]
        delegate?.didSelectTeam(team: selectedTeam)
        
        dropdownButton.setTitle(teamOptions[indexPath.row], for: .normal)
        isDropdownVisible = false
        dropdownTableView.isHidden = true
    }
}

//MARK: - 회원가입 API
extension SignUpPageViewController {

    private func userIdUniqueCheck() {
        guard let userId = idTextField.text, !userId.isEmpty else {
            print("‼️아이디 입력 필요")
            return
        }
        let endpt = "http://20.41.113.4/auth/check-userid-unique"
        let parameters: [String: Any] = ["user_cus_id": "유저아이디값"]
        
        AF.request(endpt, method: .post, parameters: parameters, encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate()
//        .responseDecodable(of: userIdCheck.self) { response in
//            switch response.result {
//            case .success(let value):
//                print("✅ 성공 응답: \(value)")
//                
//            case .failure(let error):
//                print("❌ 요청 실패: \(error.localizedDescription)")
//                
//                if let data = response.data,
//                   let jsonString = String(data: data, encoding: .utf8) {
//                    print("받은 에러 응답 JSON: \(jsonString)")
//                }
//            }
//        }
    }
      private func signUp() {

        let email = emailTextField.text ?? ""
        let token = verificationTextField.text ?? ""
        
        // 1단계: 이메일 중복 확인
        checkEmailUnique(email: email) { result in
            switch result {
            case .success(let response):
                print("✅ 이메일 중복 확인 성공: \(response.message)")
                
                // 2단계: 인증번호 확인
                self.checkEmailToken(email: email, token: token) { result in
                    switch result {
                    case .success(let tokenResponse):
                        print("✅ 이메일 토큰 확인 성공: \(tokenResponse.message)")
                        
                        // ✅ 인증 성공 시 이메일 저장
                        self.userEmail = email
                        
                        // 3단계: 최종 회원가입 요청
                        self.signUpRequest(email: self.userEmail,
                                           id: self.userID,
                                           password: self.userPW,
                                           nick: self.userNick,
                                           team: self.userTeam) { result in
                            switch result {
                            case .success(let signUpResponse):
                                print("🎉 회원가입 성공: \(signUpResponse.message)")
                            case .failure(let error):
                                print("❌ 회원가입 실패: \(error.localizedDescription)")
                            }
                        }
                        
                    case .failure(let error):
                        print("❌ 인증번호 불일치: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("❌ 이메일 중복됨 또는 네트워크 오류: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkEmailUnique(email: String, completion: @escaping (Result<EmailUniqueResponse, AFError>) -> Void) {
        let url = endpt + "auth/check-email-unique"
        let parameters = EmailUniqueRequest(email: email)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
        .validate()
        .responseDecodable(of: EmailUniqueResponse.self) { response in
            completion(response.result)
        }
    }
    
    private func checkEmailToken(email: String, token: String, completion: @escaping (Result<EmailTokenCheckResponse, AFError>) -> Void) {
        let url = endpt + "auth/email-token-check"
        let parameters = EmailTokenCheckRequest(email: email, emailToken: token)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
        .validate()
        .responseDecodable(of: EmailTokenCheckResponse.self) { response in
            completion(response.result)
        }
    }

    private func signUpRequest(email: String, id: String, password: String, nick: String?, team: Int?, completion: @escaping (Result<SignUpResponse, AFError>) -> Void) {
        let url = endpt + "auth/email-signup"
        let parameters = SignUpRequest(email: userEmail, id: userID, password: userPW, nick: userNick, team: userTeam)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
        .validate()
        .responseDecodable(of: SignUpResponse.self) { response in
            completion(response.result)
        }
    }
}
