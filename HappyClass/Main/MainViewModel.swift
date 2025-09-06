//
//  MainViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class MainViewModel: BaseViewModel {
    
    private let apiService: APIService
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let courses: Driver<[Courses]>
        let errorMessage: Driver<String>
        let amountText: Driver<String>
    }
    
    init(service: APIService) {
        self.apiService = service
    }
    
    func transform(input: Input) -> Output {
        
        let errorText = PublishRelay<String>()
        let list = BehaviorRelay<[Courses]>(value: [])
        let amountText = PublishRelay<String>()
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> Single<Result<CoursesInfo, AFError>> in
                guard let self else { return .never() }
                return self.apiService.fetchData(Router.sesac(.courses(nil)))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let data):
                    list.accept(data.data)
                case .failure(let error):
                    errorText.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        
        return Output(courses: list.asDriver(), errorMessage: errorText.asDriver(onErrorDriveWith: .empty()), amountText: amountText.asDriver(onErrorDriveWith: .empty()))
     
    }
}
