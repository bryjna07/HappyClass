//
//  CommentListViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class CommentListViewModel: BaseViewModel {
    
    let apiService: APIService
    private let disposeBag = DisposeBag()
    private let data: [Comment]
    private let course: Course
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let commentDeleteTap: Observable<Comment>
    }
    
    struct Output {
        let list: Driver<[Comment]>
        let course: Driver<Course>
        let errorMessage: Driver<String>
    }
    
    init(service: APIService, data: [Comment], course: Course) {
        self.apiService = service
        self.data = data
        self.course = course
    }
    
    func transform(input: Input) -> Output {
        
        let comments = BehaviorRelay<[Comment]>(value: [])
        let course = BehaviorRelay<Course>(value: course)
        let errorText = PublishRelay<String>()
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                comments.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .flatMap { [weak self] data -> Single<Result<CommentInfoDTO, ResponseError>> in
                guard let self else { return .never() }
                return self.apiService.fetchDataWithResponseError(Router.comment(.readComments(self.course.id)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let dto):
                    let commentList = dto.toDomain().data
                    comments.accept(commentList)
                case .failure(let error):
                    errorText.accept(error.userResponse)
                }
            }
            .disposed(by: disposeBag)
        
        input.commentDeleteTap
            .flatMap { [weak self] data -> Single<Result<ResponseDTO, ResponseError>> in
                guard let self else { return .never() }
                return self.apiService.fetchDataWithResponseError(Router.comment(.deleteComments(self.course.id, data.id)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let dto):
                    dump(dto)
                case .failure(let error):
                    course.accept(owner.course) // 댓글 삭제 시 새로고침
                    errorText.accept(error.userResponse)
                }
            }
            .disposed(by: disposeBag)
        
        course
            .flatMap { [weak self] data -> Single<Result<CommentInfoDTO, ResponseError>> in
                guard let self else { return .never() }
                return self.apiService.fetchDataWithResponseError(Router.comment(.readComments(data.id)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let dto):
                    let commentList = dto.toDomain().data
                    comments.accept(commentList)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(list: comments.asDriver(), course: course.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorText.asDriver(onErrorDriveWith: .empty()))
    }
}
