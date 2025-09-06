//
//  LoginView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class LoginView: BaseView {
    
    private let imageView = UIImageView().then {
        $0.image = .splash
        $0.contentMode = .scaleAspectFit
    }
    
    let emailFieldView = LoginFieldView().then {
        $0.label.text = "이메일"
        $0.textField.placeholder = "이메일을 입력하세요"
    }
    
    let passwordFieldView = LoginFieldView().then {
        $0.label.text = "비밀번호"
        $0.textField.placeholder = "비밀번호를 입력하세요"
        $0.textField.isSecureTextEntry = true
    }
    
    let loginButton = PointButton(title: "로그인")
    
    let validLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .point
        $0.textAlignment = .center
    }

}

extension LoginView {
    override func configureHierarchy() {
        [
            imageView,
            emailFieldView,
            passwordFieldView,
            loginButton,
            validLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        emailFieldView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        passwordFieldView.snp.makeConstraints {
            $0.top.equalTo(emailFieldView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordFieldView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
        
        validLabel.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
    }
}

