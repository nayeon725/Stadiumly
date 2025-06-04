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
    
    private let changePWButton = UIButton()
    private let toggleButton = UIButton(type: .system)
    private var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTitle()
        setupEmailSection()
        setupCodeSection()
        setupPWChangeSection()
        setupButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        findPWTitle.addGestureRecognizer(tapGesture)
        
        emailTF.addTarget(self, action: #selector(emailTFDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(pwTFDidChange), for: .editingChanged)
        
        // 👇 키보드 내리는 제스처 등록
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateEmail(_ text: String) {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        
        emailValidateLabel.textColor = result ? .blue : .red
        emailValidateLabel.text = result ? "" : "올바른 이메일을 입력해주세요."
        emailValidateLabel.font = .systemFont(ofSize: 13, weight: .light)
        emailValidateLabel.isHidden = false
        emailValidateLabel.textAlignment = .left
    }
    
    func validatePassword(_ text: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,16}$"
        let result = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        
        pwValidateLabel.textColor = result ? .blue : .red
        pwValidateLabel.text = result ? "비밀번호 형식이 일치합니다." : "비밀번호 형식을 확인해주세요."
        pwValidateLabel.font = .systemFont(ofSize: 13, weight: .light)
        pwValidateLabel.isHidden = false
        pwValidateLabel.textAlignment = .left
    }
    
//    private func configureTextField(to textField:UITextField, width: CGFloat = 10) {
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: idTextField.frame.height))
//            textField.leftView = paddingView
//            textField.leftViewMode = .always
//            textField.layer.borderWidth = 0.8
//            textField.layer.borderColor = UIColor.gray.cgColor
//            textField.layer.cornerRadius = 20
//        }
    
    @objc private func logoTapped() {
        // 화면 전환 동작 (예: pull)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pwTFDidChange() {
        // 입력 중일 때 이전 타이머 무효화
        pwValidationTimer?.invalidate()
        
        let text = passwordTF.text ?? ""
        
        // 입력이 없으면 라벨 숨김
        if text.isEmpty {
            pwValidateLabel.isHidden = true
            return
        }
        
        pwValidationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { [weak self] _ in
            self?.validatePassword(text)
        })
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
            self?.validateEmail(text)
        })
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTF.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        // 커서 위치 리셋 이슈 방지 (isSecureTextEntry 토글 시 커서가 앞으로 이동하는 문제 해결)
        let currentText = passwordTF.text
        passwordTF.text = nil
        passwordTF.text = currentText
    }
    
    private func setupTitle() {
        findPWTitle.text = "비밀번호 찾기"
        findPWTitle.textColor = .label
        findPWTitle.textAlignment = .center
        findPWTitle.isUserInteractionEnabled = true
        findPWTitle.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        view.addSubview(findPWTitle)
        findPWTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descLabel.text = "비밀번호 찾기를 위해,\n이메일 인증이 필요합니다."
        descLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        descLabel.numberOfLines = 0
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(findPWTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().offset(20)
        }
    }
    
    // 이메일 섹션 아이템
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
        
        let emailButton = UIButton()
        emailButton.setTitle("인증번호 받기", for: .normal)
        emailButton.setTitleColor(.black, for: .normal)
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 20
        emailButton.layer.masksToBounds = true
        
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
        
        view.addSubview(emailStack)
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
        
        let codeTF = UITextField()
        codeTF.placeholder = "인증번호 입력"
        codeTF.borderStyle = .roundedRect
        codeTF.layer.cornerRadius = 20
        codeTF.layer.masksToBounds = true
        
        let codeButton = UIButton()
        codeButton.setTitle("인증번호 확인", for: .normal)
        codeButton.setTitleColor(.black, for: .normal)
        codeButton.backgroundColor = .systemGray4
        codeButton.layer.cornerRadius = 20
        codeButton.layer.masksToBounds = true
        
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
        
        view.addSubview(codeStack)
        codeStack.snp.makeConstraints { make in
            make.top.equalTo(emailStack.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(emailStack.snp.horizontalEdges)
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
        
        let descRuleLabel = UILabel()
        descRuleLabel.text = "영문, 숫자, 특수문자 중 2가지 이상 조합하여 8~16자로 입력해주세요."
        descRuleLabel.font = .systemFont(ofSize: 13, weight: .light)
        
        PWStack = UIStackView(arrangedSubviews: [titleLabel, passwordTF, descRuleLabel, pwValidateLabel])
        PWStack.axis = .vertical
        PWStack.alignment = .leading
        PWStack.distribution = .fillProportionally
        PWStack.spacing = 8
        
        view.addSubview(PWStack)
        PWStack.snp.makeConstraints { make in
            make.top.equalTo(codeStack.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(codeStack.snp.horizontalEdges)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(PWStack.snp.horizontalEdges)
        }
        
        // 👁 버튼 설정
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        // 버튼을 텍스트필드 오른쪽에 넣기
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
        
        view.addSubview(changePWButton)
        changePWButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalToSuperview().inset(70)
            make.height.equalTo(50)
        }
    }
}
