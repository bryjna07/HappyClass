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
        let commentDeleteTap: Observable<Comment>
    }
    
    struct Output {
        let list: Driver<[Comment]>
        let course: Driver<Course>
    }
    
    init(service: APIService, data: [Comment], course: Course) {
        self.apiService = service
        self.data = data
        self.course = course
    }
    
    func transform(input: Input) -> Output {
        
        let comments = BehaviorRelay<[Comment]>(value: [])
        let course = BehaviorRelay<Course>(value: course)
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                comments.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.commentDeleteTap
            .flatMap { [weak self] data -> Single<Result<ResponseMessage, AFError>> in
                guard let self else { return .never() }
                return self.apiService.fetchData(Router.sesac(.deleteComments(self.course.classId, data.commentId)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    dump(value)
                case .failure(let error):
                    course.accept(owner.course) // 댓글 삭제 시 새로고침
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        course
            .flatMap { [weak self] data -> Single<Result<CommentInfo, AFError>> in
                guard let self else { return .never() }
                return self.apiService.fetchData(Router.sesac(.readComments(data.classId)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    dump(value)
                    comments.accept(value.data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(list: comments.asDriver(), course: course.asDriver(onErrorDriveWith: .empty()))
    }
}
