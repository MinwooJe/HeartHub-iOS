//
//  SignUpCoordinator.swift
//  HeartHub
//
//  Created by 이태영 on 2023/09/23.
//

import UIKit

final class SignUpCoordinator {
    private let navigationController: UINavigationController
    private let signUpUseCase = SignUpUseCase()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: Public Interface
extension SignUpCoordinator: SignUpCoordinatable {
    func start() {
        toStartDateInput()
    }
    
    private func toStartDateInput() {
        let startDateInputViewController = StartDateInputViewController(
            viewModel: StartDateInputViewModel(
                coordinator: self,
                signUpUseCase: signUpUseCase
            )
        )
        navigationController.pushViewController(startDateInputViewController, animated: true)
    }
}
