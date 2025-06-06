//
//  FindPWViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 6/2/25.
//

import UIKit
import SnapKit

class FindPWViewController: UIViewController {

    private var emailValidationTimer: Timer?
    private var pwValidationTimer: Timer?

    private var insertedEmail: String = ""
    private var insertedCode: String = ""

    private var emailStack = UIStackView()
    private var codeStack = UIStackView()
    private var PWStack = UIStackView()

    private let descLabel = UILabel()

    private let emailValidateLabel = UILabel()
    private let emailTF = UITextField()

    private let findPWTitle = UILabel()
    private let pwValidateLabel = UILabel()
    private let passwordTF = UITextField()
    private let codeTF = UITextField()

    private let changePWButton = UIButton()
    private let toggleButton = UIButton(type: .system)
    private var isPasswordVisible = false

    // 스크롤뷰 및 컨텐츠뷰
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        setupPWChangeSection()
        setupButton()

        emailTF.addTarget(self, action: #selector(emailTFDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(pwTFDidChange), for: .editingChanged)

        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)

        // 키보드 이벤트 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 화면 처음 열릴 때 emailTF 자동 포커스
        emailTF.becomeFirstResponder()
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(findPWTitle.snp.centerY)
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()  // 가로 스크롤 없음
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrameValue.cgRectValue.height

        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        findPWTitle.text = "비밀번호 찾기"
        findPWTitle.textColor = .label
        findPWTitle.textAlignment = .center
        findPWTitle.isUserInteractionEnabled = true
        findPWTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)

        contentView.addSubview(findPWTitle)
        findPWTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        descLabel.text = "비밀번호 찾기를 위해,\n이메일 인증이 필요합니다."
        descLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        descLabel.numberOfLines = 0

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(findPWTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupEmailSection() {
        let titleLabel = UILabel()
        titleLabel.text = "이메일 입력"
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)

        emailTF.placeholder = "이메일 입력"
        emailTF.borderStyle = .roundedRect
        emailTF.layer.cornerRadius = 20
        emailTF.layer.borderWidth = 0.8
        emailTF.layer.borderColor = UIColor.systemGray4.cgColor
        emailTF.layer.masksToBounds = true
        emailTF.keyboardType = .emailAddress
        configureTextField(to: emailTF)

        let emailButton = UIButton()
        emailButton.setTitle("인증번호 받기", for: .normal)
        emailButton.setTitleColor(.black, for: .normal)
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 20
        emailButton.layer.masksToBounds = true
        emailButton.addTarget(self, action: #selector(sendVerificationCode), for: .touchUpInside)

        emailTF.setContentHuggingPriority(.defaultLow, for: .horizontal)
        emailButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let horizontalStack = UIStackView(arrangedSubviews: [emailTF, emailButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .leading
        horizontalStack.distribution = .fillProportionally
        horizontalStack.spacing = 8

        emailStack = UIStackView(arrangedSubviews: [titleLabel, horizontalStack, emailValidateLabel])
        emailStack.axis = .vertical
        emailStack.alignment = .fill
        emailStack.spacing = 10

        contentView.addSubview(emailStack)
        emailStack.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        emailTF.snp.makeConstraints { make in
            make.width.equalTo(emailButton.snp.width).multipliedBy(5.0 / 3.0)
        }
    }

    private func setupCodeSection() {
        let titleLabel = UILabel()
        titleLabel.text = "인증메일을 발송했습니다.\n메일 확인 후 인증번호를 입력해주세요."
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        titleLabel.numberOfLines = 0

        codeTF.placeholder = "인증번호 입력"
        codeTF.borderStyle = .roundedRect
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
        codeButton.addTarget(self, action: #selector(moveFocusToPWField), for: .touchUpInside)

        codeTF.setContentHuggingPriority(.defaultLow, for: .horizontal)
        codeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let horizontalStack = UIStackView(arrangedSubviews: [codeTF, codeButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .leading
        horizontalStack.distribution = .fillProportionally
        horizontalStack.spacing = 8

        codeStack = UIStackView(arrangedSubviews: [titleLabel, horizontalStack])
        codeStack.axis = .vertical
        codeStack.alignment = .fill
        codeStack.spacing = 10

        contentView.addSubview(codeStack)
        codeStack.snp.makeConstraints { make in
            make.top.equalTo(emailStack.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailStack)
        }

        codeTF.snp.makeConstraints { make in
            make.width.equalTo(codeButton.snp.width).multipliedBy(5.0 / 3.0)
        }
    }

    private func setupPWChangeSection() {
        let titleLabel = UILabel()
        titleLabel.text = "인증이 완료되었습니다.\n비밀번호를 재설정 해주세요."
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        titleLabel.numberOfLines = 0

        passwordTF.placeholder = "비밀번호 입력"
        passwordTF.borderStyle = .roundedRect
        passwordTF.isSecureTextEntry = true
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.layer.cornerRadius = 20
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.borderWidth = 0.8
        passwordTF.layer.borderColor = UIColor.systemGray4.cgColor
        configureTextField(to: passwordTF)

        let descRuleLabel = UILabel()
        descRuleLabel.text = "영문, 숫자, 특수문자 중 2가지 이상 조합하여 8~16자로 입력해주세요."
        descRuleLabel.font = .systemFont(ofSize: 13, weight: .light)

        PWStack = UIStackView(arrangedSubviews: [titleLabel, passwordTF, descRuleLabel, pwValidateLabel])
        PWStack.axis = .vertical
        PWStack.alignment = .leading
        PWStack.distribution = .fillProportionally
        PWStack.spacing = 8

        contentView.addSubview(PWStack)
        PWStack.snp.makeConstraints { make in
            make.top.equalTo(codeStack.snp.bottom).offset(30)
            make.leading.trailing.equalTo(codeStack)
            make.bottom.lessThanOrEqualToSuperview().inset(20) // 컨텐츠뷰 bottom 제약 추가
        }

        passwordTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        passwordTF.rightView = toggleButton
        passwordTF.rightViewMode = .always
    }

    private func setupButton() {
        changePWButton.setTitle("비밀번호 변경", for: .normal)
        changePWButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        changePWButton.setTitleColor(.black, for: .normal)
        changePWButton.backgroundColor = .systemGray4
        changePWButton.layer.cornerRadius = 10
        changePWButton.layer.masksToBounds = true

        contentView.addSubview(changePWButton)
        changePWButton.snp.makeConstraints { make in
            make.top.equalTo(PWStack.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(70)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(10) // 컨텐츠뷰 bottom과 붙도록
        }
    }

    // 이하 기존 유효성 검사, 버튼 액션 등 그대로 유지

    private func validateEmail(_ text: String) {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)

        emailValidateLabel.textColor = result ? .blue : .red
        emailValidateLabel.text = result ? "" : "올바른 이메일을 입력해주세요."
        emailValidateLabel.font = .systemFont(ofSize: 13, weight: .light)
        emailValidateLabel.isHidden = false
        emailValidateLabel.textAlignment = .left
    }

    private func validatePassword(_ text: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,16}$"
        let result = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)

        pwValidateLabel.textColor = result ? .blue : .red
        pwValidateLabel.text = result ? "비밀번호 형식이 일치합니다." : "비밀번호 형식을 확인해주세요."
        pwValidateLabel.font = .systemFont(ofSize: 13, weight: .light)
        pwValidateLabel.isHidden = false
        pwValidateLabel.textAlignment = .left
    }
    
    private func networkingWithBE() {
        
    }

    @objc private func emailTFDidChange() {
        emailValidationTimer?.invalidate()

        let text = emailTF.text ?? ""

        if text.isEmpty {
            emailValidateLabel.isHidden = true
            return
        }

        emailValidationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { [weak self] _ in
            self?.validateEmail(text)
        })
    }

    @objc private func pwTFDidChange() {
        pwValidationTimer?.invalidate()

        let text = passwordTF.text ?? ""

        if text.isEmpty {
            pwValidateLabel.isHidden = true
            return
        }

        pwValidationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { [weak self] _ in
            self?.validatePassword(text)
        })
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTF.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)

        // 커서 위치 리셋 이슈 방지
        let currentText = passwordTF.text
        passwordTF.text = nil
        passwordTF.text = currentText
    }
    
    @objc private func sendVerificationCode() {
        // 인증번호 자동 포커스
        codeTF.becomeFirstResponder()
    }
    
    @objc private func moveFocusToPWField() {
        passwordTF.becomeFirstResponder()
    }
    
    @objc private func sendEmailToBE() {
        
    }
    
    @objc private func sendPasswordToBE() {
        
    }
}
