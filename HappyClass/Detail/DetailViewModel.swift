//
//  DetailViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class DetailViewModel: BaseViewModel {
    
    let apiService: APIService
    private let classId: String
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let data: Driver<Course>
        let imageList: Driver<[String]>
        let commentCount: Driver<Int>
        let commentList: Driver<[Comment]>
        let errorMessage: Driver<String>
    }
    
    init(service: APIService, classId: String) {
        self.apiService = service
        self.classId = classId
    }
    
    func transform(input: Input) -> Output {
        
        let data = PublishRelay<Course>()
        let imageList = BehaviorRelay<[String]>(value: [])
        let commentCount = BehaviorRelay<Int>(value: 0)
        let commentList = BehaviorRelay<[Comment]>(value: [])
        let errorText = PublishRelay<String>()
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> Single<Result<Course, ResponseError>> in
                guard let self else { return .never() }
                    return self.apiService
                    .fetchDataWithResponseError(Router.sesac(.courseDetail(self.classId)))
                }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let course):
                    data.accept(course)
                    if let images = course.imageURLS {
                        imageList.accept(images)
                    }
                case .failure(let error):
                    errorText.accept(error.userResponse)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .flatMap { [weak self] _ -> Single<Result<CommentInfo, ResponseError>> in
                guard let self else { return .never() }
                return self.apiService.fetchDataWithResponseError(Router.sesac(.readComments(self.classId)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    commentCount.accept(data.data.count)
                    commentList.accept(data.data)
                case .failure(let error):
                    errorText.accept(error.userResponse)
                }
            }
            .disposed(by: disposeBag)

        return Output(data: data.asDriver(onErrorDriveWith: .empty()),
                      imageList: imageList.asDriver(),
                      commentCount: commentCount.asDriver(),
                      commentList: commentList.asDriver(),
                      errorMessage: errorText.asDriver(onErrorDriveWith: .empty())
        )
    }
}
