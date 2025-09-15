//
//  LoginView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class LoginViewModel: BaseViewModel {
    
    let apiService: APIService
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let loginButtonTap: Observable<Void>
    }
    
    struct Output {
        let validText: Driver<String>
        let loginButtonActive: Driver<Bool>
        let loginResult: Driver<Bool>
        let loginError: Driver<LoginError>
    }
    
    init(service: APIService) {
        self.apiService = service
    }
    
    func transform(input: Input) -> Output {
        
        let validText = PublishRelay<String>()
        let networkError = PublishRelay<LoginError>()
        
        let emailAndPassword = Observable
                .combineLatest(input.emailText, input.passwordText)
        
        let validResult = emailAndPassword
            .map { email, password -> Bool in
                guard !email.isEmpty, !password.isEmpty else {
                    validText.accept("이메일과 비밀번호를 입력해주세요")
                    return false
                }
                guard email.contains("@"), email.contains(".com") else {
                    validText.accept("@와 .com을 포함해주세요")
                    return false
                }
                guard password.count >= 2, password.count < 10 else {
                    validText.accept("2글자 이상 10글자 미만으로 설정해주세요")
                    return false
                }
                validText.accept("")
                return true
            }
        
        
        let loginResult = input.loginButtonTap
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { [weak self] email, password -> Single<Bool> in
                guard let self else { return .just(false) }
                let param: Parameters = [
                    "email": email,
                    "password": password
                ]
                return self.apiService.fetchDataWithLoginError(Router.sesac(.login(param)))
                    .map { (response: Result<ProfileDTO, LoginError>) -> Bool in
                        switch response {
                        case .success(let dto):
                            let user = dto.toDomain()
                            UserDefaultsManager.shared.token = dto.accessToken ?? ""
                            UserDefaultsManager.shared.id = user.userId
                            return true
                        case .failure(let error):
                            networkError.accept(error)
                            return false
                        }
                    }
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(validText: validText.asDriver(onErrorDriveWith: .empty()),
                      loginButtonActive: validResult.asDriver(onErrorJustReturn: false),
                      loginResult: loginResult,
                      loginError: networkError.asDriver(onErrorDriveWith: .empty())
        )
    }

}
