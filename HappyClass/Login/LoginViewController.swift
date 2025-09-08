//
//  LoginViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class LoginViewController: BaseViewController {
    
    private let loginView = LoginView()
    private let viewModel : LoginViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.emailFieldView.textField.becomeFirstResponder()
        bind()
    }
    
    private func bind() {
        
        let input = LoginViewModel.Input(
            emailText: loginView.emailFieldView.textField.rx.text.orEmpty.asObservable(),
            passwordText: loginView.passwordFieldView.textField.rx.text.orEmpty.asObservable(),
            loginButtonTap: loginView.loginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.validText
            .drive(with: self) { owner, value in
                owner.loginView.validLabel.text = value
            }
            .disposed(by: disposeBag)

        output.loginButtonActive
            .drive(with: self) { owner, value in
                owner.loginView.loginButton.isEnabled =  value ? true : false
                owner.loginView.loginButton.backgroundColor = value ? .point : .disSelected
            }
            .disposed(by: disposeBag)
        
        output.loginResult
            .drive(with: self) { owner, value in
                if value {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let tabBar = TabBarController(service: owner.viewModel.apiService)
                        sceneDelegate.changeRootViewController(tabBar)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.loginError
            .drive(with: self) { owner, error in
                owner.view.makeToast(error.userResponse, position: .bottom)
            }
            .disposed(by: disposeBag)

        loginView.emailFieldView.textField.rx.controlEvent(.editingDidEndOnExit)
            .bind(with: self) { owner, _ in
                owner.loginView.passwordFieldView.textField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        loginView.passwordFieldView.textField.rx.controlEvent(.editingDidEndOnExit)
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
    }
}
