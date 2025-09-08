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
    
    let apiService: APIService
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let selectedCategories: Observable<Set<Category>>
        let selectedSort: Observable<Sort>
        let likeTap: Observable<(String, Bool)>
    }
    
    struct Output {
        let courses: Driver<[Course]>
        let errorMessage: Driver<String>
        let amountText: Driver<String>
    }
    
    init(service: APIService) {
        self.apiService = service
    }
    
    func transform(input: Input) -> Output {
        
        let errorText = PublishRelay<String>()
        let list = BehaviorRelay<[Course]>(value: [])
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> Single<Result<CoursesInfo, ResponseError>> in
                guard let self else { return .never() }
                return self.apiService.fetchDataWithResponseError(Router.sesac(.courses))
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
        
        // 좋아요 버튼 업데이트
        input.likeTap
            .flatMapLatest { [weak self] (id, bool) -> Single<(String, Result<ResponseMessage, ResponseError>)> in
                guard let self else { return .never() }
                return self.apiService
                    .fetchDataWithResponseError(Router.sesac(.like(id, bool)))
                    .map { (id, $0) }
            }
            .flatMapLatest { [weak self] (id, likeResult) -> Single<(String, Result<Course, ResponseError>)> in
                guard let self else { return .never() }
                switch likeResult {
                case .success:
                    return self.apiService
                        .fetchDataWithResponseError(Router.sesac(.courseDetail(id)))
                        .map { (id, $0) }
                case .failure(let error):
                    errorText.accept(error.userResponse)
                    return .never()
                }
            }
            .subscribe(onNext: { (id, result) in
                switch result {
                case .success(let course):
                        var coursesList = list.value
                        if let index = coursesList.firstIndex(where: { $0.classId == id }) {
                            coursesList[index] = course
                            list.accept(coursesList)
                        }
                case .failure(let error):
                    errorText.accept(error.userResponse)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            courses: sorted.asDriver(onErrorJustReturn: []),
            errorMessage: errorText.asDriver(onErrorDriveWith: .empty()),
            amountText: amountText.asDriver(onErrorJustReturn: "0개")
        )
     
    }
}
