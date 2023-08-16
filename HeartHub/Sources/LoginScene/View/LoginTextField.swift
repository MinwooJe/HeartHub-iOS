//
//  LoginTextFieldView.swift
//  HeartHub
//
//  Created by 제민우 on 2023/08/07.
//

import UIKit

final class LoginTextField: UITextField {

    private let insets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    init(placeholder: String, keyboardType: UIKeyboardType, isSecureTextEntry: Bool) {
        super.init(frame: .zero)
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        
        configureTextField()
        configureLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}

extension LoginTextField {
    private func configureTextField() {
        backgroundColor = .clear
        textColor = .white
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        clearsOnBeginEditing = false
        font = UIFont(name: "Pretendard-Regular", size: 16)
        textAlignment = .left
        
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        layer.borderWidth = 1
    }

    
    private func configureLayout() {
        
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // MARK: loginTextFieldView Constraints
            centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12)
        ])
    }
}
