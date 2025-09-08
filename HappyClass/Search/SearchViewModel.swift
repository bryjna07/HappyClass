//
//  SearchViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class SearchViewModel: BaseViewModel {
    
    let apiService: APIService
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: Observable<String>
        let likeTap: Observable<(String, Bool)>
    }
    
    struct Output {
        let list: Driver<[Course]>
        let errorMessage: Driver<String>
        let showEmptyView: Driver<(Bool, String?)>
    }
    
    init(service: APIService) {
        self.apiService = service
    }
    
    func transform(input: Input) -> Output {
        
        let errorText = PublishRelay<String>()
        let list = BehaviorRelay<[Course]>(value: [])
        let showEmptyView = BehaviorRelay<(Bool, String?)>(value: (true, "원하는 클래스가 있으신가요?"))
        
        input.searchButtonTap
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .flatMap { [weak self] text -> Single<Result<CoursesInfo, ResponseError>> in
                guard let self else { return .never() }
                return self.apiService.fetchDataWithResponseError(Router.sesac(.search(text)))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let data):
                    list.accept(data.data)
                    if data.data.isEmpty {
                        showEmptyView.accept((true, "검색 결과가 없습니다."))
                    } else {
                        showEmptyView.accept((false, nil))
                    }
                case .failure(let error):
                    errorText.accept(error.userResponse)
                }
            }
            .disposed(by: disposeBag)
        
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

        return Output(list: list.asDriver(), errorMessage: errorText.asDriver(onErrorDriveWith: .empty()),
                      showEmptyView: showEmptyView.asDriver())
    }
}
