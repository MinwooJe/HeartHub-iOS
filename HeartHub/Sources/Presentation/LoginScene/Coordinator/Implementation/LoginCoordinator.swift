//
//  LoginCoordinator.swift
//  HeartHub
//
//  Created by 이태영 on 2023/09/15.
//

import UIKit

protocol LoginCoordinatable: Coordinatable {
    func toFindPassword()
    func toFindID()
    func toSignUp()
}

final class LoginCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Public Interface
extension LoginCoordinator: LoginCoordinatable {
    func start() {
        let loginViewController = LoginViewController()
        navigationController.viewControllers = [loginViewController]
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func toFindPassword() {
        
    }
    
    func toFindID() {
        
    }
    
    func toSignUp() {
        
    }
}
