//
//  LoginViewController.swift
//  HeartHub
//
//  Created by 제민우 on 2023/07/07.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
        
    }
    
    func setupAddTarget() {
        loginView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginView.findIdBtn.addTarget(self, action: #selector(didTapFindIdButton), for: .touchUpInside)
        loginView.signUpBtn.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        loginView.findPwBtn.addTarget(self, action: #selector(didTapFindPwButton), for: .touchUpInside)
    }

    @objc private func didTapLoginButton() {
        print("로그인 버튼이 눌렸습니다.")
        let findPwVC = SignUpTermAgreeViewController()
       navigationController?.pushViewController(findPwVC, animated: true)
    }
    
    @objc private func didTapFindPwButton() {
         let findPwVC = FindPwViewController()
        navigationController?.pushViewController(findPwVC, animated: true)

    }
    
    @objc private func didTapSignUpButton() {
        let signUpVC = SignUpStartDateViewController()
        navigationController?.pushViewController(signUpVC, animated: true)

    }
    
    @objc private func didTapFindIdButton() {
        let findIdVC = FindIdViewController()
        navigationController?.pushViewController(findIdVC, animated: true)
    }
}
