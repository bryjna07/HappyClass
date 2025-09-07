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
        let selectedCategories: Observable<Set<Category>>
        let selectedSort: Observable<Sort>
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

        // 카테고리 선택된 데이터로 필터링
        let filtered = Observable.combineLatest(
            list.asObservable(),
            input.selectedCategories) { items, categories in
            if categories.isEmpty {
                return items
            }
            let categoryNums = categories.map { $0.rawValue }
            return items.filter { categoryNums.contains($0.category) }
        }
        
        let sorted = Observable.combineLatest(
            filtered,
            input.selectedSort) { items, sort in
                switch sort {
                case .latest:
                    return items
                case .price:
                    return items.sorted {
                        ($0.price ?? 0) > ($1.price ?? 0)
                    }
                }
            }

        let amountText = sorted
            .map { "\($0.count.formatted())개" }

        return Output(
            courses: sorted.asDriver(onErrorJustReturn: []),
            errorMessage: errorText.asDriver(onErrorDriveWith: .empty()),
            amountText: amountText.asDriver(onErrorJustReturn: "0개")
        )
     
    }
}
