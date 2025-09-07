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
    }
    
    struct Output {
        let data: Driver<Course>
        let imageList: Driver<[String]>
        let commentCount: Driver<Int>
        let commentList: Driver<[Comment]>
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
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> Single<Result<Course, AFError>> in
                guard let self else { return .never() }
                    return self.apiService
                    .fetchData(Router.sesac(.courseDetail(self.classId)))
                }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let course):
                    data.accept(course)
                    if let images = course.imageURLS {
                        imageList.accept(images)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> Single<Result<CommentInfo, AFError>> in
                guard let self else { return .never() }
                return self.apiService.fetchData(Router.sesac(.readComments(self.classId)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    commentCount.accept(data.data.count)
                    commentList.accept(data.data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        return Output(data: data.asDriver(onErrorDriveWith: .empty()),
                      imageList: imageList.asDriver(),
                      commentCount: commentCount.asDriver(),
                      commentList: commentList.asDriver()
        )
    }
}
