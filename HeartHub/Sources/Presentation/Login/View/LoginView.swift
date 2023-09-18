//
//  LoginView.swift
//  HeartHub
//
//  Created by 제민우 on 2023/07/10.
//

import UIKit

final class LoginView: UIView {
    private let loginBackGroundView = LoginBackgroundView()
    
    let enterIdTextField = LoginTextField(
        placeholder: "아이디를 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: false
    )
    
    let enterPwTextField = LoginTextField(
        placeholder: "비밀번호를 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: true
    )
    
    private lazy var passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("표시", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
        return button
    }()
    
    // 로그인 버튼
    var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Pretendard-SemiBold", size: 16)
        button.setTitleColor(UIColor(red: 0.98, green: 0.18, blue: 0.74, alpha: 1), for: .normal)
        button.contentVerticalAlignment = .center
        return button
    }()
    
    // 아이디 + 비밀번호 + 로그인 버튼 스택뷰
    private lazy var idPwLoginBtnStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [enterIdTextField, enterPwTextField, loginButton])
        stview.spacing = 8
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        stview.setCustomSpacing(20, after: enterPwTextField)
        return stview
    }()
    
    // MARK: 아이디 찾기 + 회원가입 + 비밀번호찾기 버튼
    // 아이디 찾기 버튼
    var findIdBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("아이디 찾기", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Pretendard-Regular", size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        return button
    }()
    
    // 회원가입 버튼
    var signUpBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Pretendard-Regular", size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        return button
    }()
    
    // 비밀번호 찾기 버튼
    var findPwBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("비밀번호 찾기", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Pretendard-Regular", size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        return button
    }()
    
    private var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        return view
    }()
    
    private var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        return view
    }()
    
    // 아이디찾기 + 선 + 회원가입 + 선 + 비밀번호 찾기 버튼 스택뷰
    private lazy var selectPageButtonStackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [findIdBtn, lineView1, signUpBtn, lineView2, findPwBtn])
        stView.spacing = 10
        stView.axis = .horizontal
        stView.distribution = .equalCentering
        stView.alignment = .center
        return stView
    }()
    
    private var idPwLoginBtnStackViewTopConstraint: NSLayoutConstraint!
    private var keyboardBackgroundViewTopConstraint: NSLayoutConstraint!
    
    // MARK: 뷰 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureNotification()
        configureSubviews()
        configureAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        configureLayout()
        super.updateConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Configure AddTarget
extension LoginView {
    private func configureAddTarget() {
        [enterIdTextField, enterPwTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
        
        passwordSecureButton.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
    }
    
    @objc private func passwordSecureModeSetting() {
        enterPwTextField.isSecureTextEntry.toggle()
    }
}

// MARK: Configure Layout
extension LoginView {
    
    private func configureInitialSetting() {
        enterIdTextField.delegate = self
        enterPwTextField.delegate = self
        loginButton.isEnabled = false
    }
    
    private func configureSubviews() {
        
        enterPwTextField.addSubview(passwordSecureButton)
        passwordSecureButton.translatesAutoresizingMaskIntoConstraints = false
        
        [loginBackGroundView,
         selectPageButtonStackView,
         idPwLoginBtnStackView,
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureLayout() {
        
        let safeArea = safeAreaLayoutGuide
        
        idPwLoginBtnStackViewTopConstraint =
        idPwLoginBtnStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 527)
        

        NSLayoutConstraint.activate([
            
            // MARK: loginBackGrondView Constraints
            loginBackGroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginBackGroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginBackGroundView.topAnchor.constraint(equalTo: topAnchor),
            loginBackGroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            // MARK: ID, PW TextField, LoginButton StackView Constraints
            idPwLoginBtnStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2037),
            idPwLoginBtnStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            idPwLoginBtnStackViewTopConstraint,
            idPwLoginBtnStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 59),
            
            passwordSecureButton.centerYAnchor.constraint(equalTo: enterPwTextField.centerYAnchor),
            passwordSecureButton.topAnchor.constraint(equalTo: enterPwTextField.topAnchor, constant: -15),
            passwordSecureButton.trailingAnchor.constraint(equalTo: enterPwTextField.trailingAnchor, constant: -8),

            // MARK: SignUp button, FindID button, FindPw button StackView Constraints
            selectPageButtonStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.028),
            selectPageButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectPageButtonStackView.topAnchor.constraint(equalTo: idPwLoginBtnStackView.bottomAnchor, constant: 28),
            selectPageButtonStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            selectPageButtonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 66),
             

            lineView1.widthAnchor.constraint(equalToConstant: 1),
            lineView1.heightAnchor.constraint(equalTo: signUpBtn.heightAnchor, multiplier: 0.5),

            lineView2.widthAnchor.constraint(equalToConstant: 1),
            lineView2.heightAnchor.constraint(equalTo: lineView1.heightAnchor)
        ])
    }
}

// MARK: 키보드 올라오고 내려갈 때 레이아웃 변경
extension LoginView {
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpAction), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func moveUpAction() {
        idPwLoginBtnStackViewTopConstraint.constant = 289
        keyboardBackgroundViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func moveDownAction() {
        idPwLoginBtnStackViewTopConstraint.constant = 527
        keyboardBackgroundViewTopConstraint.constant = frame.height
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    
}

// MARK: TextField Delegate Implement
extension LoginView: UITextFieldDelegate {
 
    // id, pw 텍스트필드 입력값 없을 시 로그인 버튼 비활성화
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let id = enterIdTextField.text, !id.isEmpty,
            let pw = enterPwTextField.text, !pw.isEmpty
        else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }

    
    // 키보드 엔터키가 눌렸을때 (다음 동작을 허락할 것인지)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 두개의 텍스트필드를 모두 종료 (키보드 내려가기)
        if enterIdTextField.text != "", enterPwTextField.text != "" {
            enterPwTextField.resignFirstResponder()
            return true
        } else if enterIdTextField.text != "" {
            enterPwTextField.becomeFirstResponder()
            return true
        }
            return false
        }
    
    // 텍스트필드 이외의 영역을 눌렀을때 키보드 내려가도록
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterIdTextField.resignFirstResponder()
        enterPwTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        // 백스페이스 감지
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        guard let text = textField.text else {
            return true
        }
        
        let maxLength: Int
        var allowedCharacterSet: CharacterSet
        
        switch textField {
        case enterIdTextField:
            maxLength = 18
            allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        case enterPwTextField:
            maxLength = 15
            allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_?+=~")

        default:
            return true
        }
        
        let newLength = text.count + string.count - range.length
        
        if newLength <= maxLength {
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: characterSet)
        } else {
            return false
        }
    }
}
