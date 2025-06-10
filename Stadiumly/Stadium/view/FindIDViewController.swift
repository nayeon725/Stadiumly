import UIKit
import SnapKit
import Alamofire

class FindIDViewController: UIViewController {
    
    // api 관련
    private let endpt = "http://20.41.113.4/"
   
    private var insertedEmail: String = ""
    private var insertedCode: String = ""
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var descLabel = UILabel()
    private var findIDTitle = UILabel()
    
    private let emailTF = UITextField()
    private let codeTF = UITextField()
    
    private var emailValidationTimer: Timer?
    private let emailValidateLabel = UILabel()
    
    private let changePWButton = UIButton()
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = .black
        return backButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupScrollView()
        setupTitle()
        setupEmailSection()
        setupCodeSection()
        setupButton()
        
        setupKeyboardObservers()
        
        emailTF.addTarget(self, action: #selector(emailTFDidChange), for: .editingChanged)
        changePWButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
        
        emailTF.delegate = self
        codeTF.delegate = self
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(findIDTitle.snp.centerY)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(25)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        backButton.addGestureRecognizer(tapGesture)

    }
    
  
    
    @objc func logoTapped() {
        // 화면 전환 동작 (예: pull)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 중요!
        }
    }
    
    
    
    private func validateEmail(_ email: String) -> Bool {
          let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
      }
    
      private func undateEmailValidateionUI(isValid: Bool) {
          emailValidateLabel.textColor = isValid ? .blue : .red
          emailValidateLabel.text = isValid ? "" : "올바른 이메일을 입력해주세요."
          emailValidateLabel.font = .systemFont(ofSize: 13, weight: .light)
          emailValidateLabel.isHidden = false
          emailValidateLabel.textAlignment = .left
      }
    
    @objc private func emailTFDidChange() {
        // 입력 중일 때 이전 타이머 무효화
        emailValidationTimer?.invalidate()
        
        let text = emailTF.text ?? ""
        
        // 입력이 없으면 라벨 숨김
        if text.isEmpty {
            emailValidateLabel.isHidden = true
            return
        }
        
        
        emailValidationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            let isValid = self.validateEmail(text)
            self.undateEmailValidateionUI(isValid: isValid)
        })
    }
    
    private func configureTextField(to textField:UITextField, width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTF.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 20
    }
    
    private func setupTitle() {
        findIDTitle.text = "아이디 찾기"
        findIDTitle.textColor = .label
        findIDTitle.textAlignment = .center
        findIDTitle.isUserInteractionEnabled = true
        findIDTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        contentView.addSubview(findIDTitle)
        findIDTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        descLabel.text = "가입 시 등록하신 이메일을 입력해주세요."
        descLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        descLabel.numberOfLines = 0
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(findIDTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupEmailSection() {
        let titleLabel = UILabel()
        titleLabel.text = "이메일 입력"
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        emailTF.placeholder = "이메일 입력"
        emailTF.borderStyle = .roundedRect
        emailTF.keyboardType = .emailAddress
        emailTF.layer.masksToBounds = true
        emailTF.layer.cornerRadius = 20
        emailTF.layer.borderWidth = 0.8
        emailTF.layer.borderColor = UIColor.systemGray4.cgColor
        configureTextField(to: emailTF)
        
        let emailButton = UIButton()
        emailButton.setTitle("인증번호 받기", for: .normal)
        emailButton.setTitleColor(.black, for: .normal)
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 20
        emailButton.layer.masksToBounds = true
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(emailTF)
        contentView.addSubview(emailButton)
        contentView.addSubview(emailValidateLabel)
        
        emailTF.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(emailButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }
        
        emailButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTF)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(emailTF.snp.width).multipliedBy(3.0 / 5.0)
            make.height.equalTo(40)
        }
        
        emailValidateLabel.snp.makeConstraints { make in
            make.top.equalTo(emailButton.snp.bottom)
            make.leading.equalTo(emailTF)
        }
    }
    
    private func setupCodeSection() {
        let titleLabel = UILabel()
        titleLabel.text = "인증메일을 발송했습니다.\n메일 확인 후 인증번호를 입력해주세요."
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        codeTF.placeholder = "인증번호 입력"
        codeTF.borderStyle = .roundedRect
        codeTF.keyboardType = .numberPad
        codeTF.layer.cornerRadius = 20
        codeTF.layer.masksToBounds = true
        codeTF.layer.borderWidth = 0.8
        codeTF.layer.borderColor = UIColor.systemGray4.cgColor
        configureTextField(to: codeTF)
        
        let codeButton = UIButton()
        codeButton.setTitle("인증번호 확인", for: .normal)
        codeButton.setTitleColor(.black, for: .normal)
        codeButton.backgroundColor = .systemGray4
        codeButton.layer.cornerRadius = 20
        codeButton.layer.masksToBounds = true
        codeButton.addTarget(self, action: #selector(checkToeknButtonTapped), for: .touchUpInside)
        contentView.addSubview(codeTF)
        contentView.addSubview(codeButton)
        
        codeTF.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(codeButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }
        
        codeButton.snp.makeConstraints { make in
            make.centerY.equalTo(codeTF)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(codeTF.snp.width).multipliedBy(3.0 / 5.0)
            make.height.equalTo(40)
        }
    }
    
    private func setupButton() {
        changePWButton.setTitle("아이디 찾기", for: .normal)
        changePWButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        changePWButton.setTitleColor(.black, for: .normal)
        changePWButton.backgroundColor = .systemGray4
        changePWButton.layer.cornerRadius = 10
        changePWButton.layer.masksToBounds = true
        
        contentView.addSubview(changePWButton)
        changePWButton.snp.makeConstraints { make in
            make.top.equalTo(codeTF.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(70)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(20) // 중요: contentView의 height 유지를 위해
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func buttonTapped() {
        let checkVC = CheckIDViewController()
        navigationController?.pushViewController(checkVC, animated: true)
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight + 20
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 20
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

extension FindIDViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(frame.insetBy(dx: 0, dy: -20), animated: true)
    }
}


extension FindIDViewController {
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    //이메일 토큰 검증후 아이디받는거
    @objc private func checkToeknButtonTapped() {
        guard let email = emailTF.text,
              let token = codeTF.text,
              !email.isEmpty, !token.isEmpty
        else {
            showAlert(title: "인증번호를 입력해주세요.", message: "이메일과 인증번호를 모두 입력해주세요.")
            return
        }
        guard validateEmail(email) else {
            showAlert(title: "이메일 형식을 입력해주세요.", message: "올바른 이메일 형식을 입력해주세요.")
            return
        }
        checkEmailToken(email: email, token: token) { result in
            switch result {
            case .success(let response):
                if response.status == "success" {
                    print("✅ 이메일 인증 성공")
                    let checkId = response.user_cus_id
                    print("⭐️User ID : \(checkId)")
                    let checkIdVC = CheckIDViewController()
                    checkIdVC.findedID = response.user_cus_id
                    self.navigationController?.pushViewController(checkIdVC, animated: true)
                } else {
                    self.showAlert(title: "인증번호를 확인해주세요", message: "인증번호가 유효하지 않습니다")
                }
            case .failure(let error):
                print("❌서버오류", error)
            }
        }
    }
    
    @objc private func emailButtonTapped() {
        guard let email = emailTF.text, !email.isEmpty else {
            showAlert(title: "이메일을 입력", message: "이메일을 입력해주세요.")
            return
        }
        guard validateEmail(email) else {
            showAlert(title: "이메일 확인", message: "이메일 형식이 잘못되었습니다.")
            return
        }
        sendEmailVerificationToken(email: email) { result in
            switch result {
            case .success(let response):
                if response.status == "success" {
                    print("✅ 인증번호 발송 성공")
                    self.showAlert(title: "인증번호가 발송되었습니다", message: "이메일을 확인해주세요")
                } else {
                    print("❌오류")
                }
            case .failure(let error):
                print("❌ 인증번호 발송 실패 :\(error)")
                self.showAlert(title: "인증번호 발송 실패", message: "잠시 후 다시 시도해주세요.")
            }
        }
    }

    //checkEmailUnique 함수 원래 이름
    private func sendEmailVerificationToken(email: String, completion: @escaping (Result<EmailUniqueResponse, AFError>) -> Void) {
        let url = endpt + "auth/find-id"
        let parameters = ["user_email" : email]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
        .validate()
        .responseDecodable(of: EmailUniqueResponse.self) { response in
            completion(response.result)
        }
    }
    //유저가 이메일로 받은거 검증
    private func checkEmailToken(email: String, token: String, completion: @escaping (Result<IdCheckResponse, AFError>) -> Void) {
        let url = endpt + "auth/find-id-email-verify"
        let parameters = FindIdEmailVerifyRequest(user_email: email, token: token)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
        .validate()
        .responseDecodable(of: IdCheckResponse.self) { response in
            completion(response.result)
        }
    }
}
