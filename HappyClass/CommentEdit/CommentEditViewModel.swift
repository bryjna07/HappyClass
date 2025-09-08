//
//  CommentEditViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class CommentEditViewModel: BaseViewModel {
    
    let apiService: APIService
    private let disposeBag = DisposeBag()
    private let data: Course
    private let comment: Comment?
    private let type: EditType
    
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let commentText: Observable<String>
        let rightButtonTap: Observable<Void>
    }
    
    struct Output {
        let course: Driver<Course>
        let commentText: Driver<String>
        let validText: Driver<(String, Bool)>
        let createButtonActive: Driver<Bool>
        let result: Driver<Bool>
        let errorMessage: Driver<String>
    }
    
    init(service: APIService, data: Course, comment: Comment? = nil, type: EditType) {
        self.apiService = service
        self.data = data
        self.comment = comment
        self.type = type
    }
    
    func transform(input: Input) -> Output {
        
        let course = BehaviorRelay<Course>(value: data)
        let validText = BehaviorRelay(value: ("0 / 300", false))
        let reponseResult = PublishRelay<Bool>()
        let buttonActive = BehaviorRelay<Bool>(value: false)
        let commentText = BehaviorRelay<String>(value: "")
        let errorText = PublishRelay<String>()
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                guard let comment = owner.comment else { return }
                commentText.accept(comment.content)
            }
            .disposed(by: disposeBag)
        

        input.commentText
            .bind(with: self) { owner, text in
                if text.count >= 2, text.count <= 200 {
                    buttonActive.accept(true)
                } else {
                    buttonActive.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.commentText
            .map {
                if $0.count > 200 {
                    return ("200자 초과", false)
                } else if $0.count >= 150 {
                    return ("\($0.count) / 200", false)
                } else {
                    return ("\($0.count) / 200", true)
                }
            }
            .bind(to: validText)
            .disposed(by: disposeBag)
        
        switch type {
        case .create:
            input.rightButtonTap
                .withLatestFrom(input.commentText)
                .distinctUntilChanged()
                .flatMap { [weak self] text -> Single<Result<Comment, ResponseError>> in
                    guard let self else { return .never() }
                    return self.apiService.fetchDataWithResponseError(Router.sesac(.createComments(self.data.classId, text)))
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let comment):
                        reponseResult.accept(true)
                    case .failure(let error):
                        reponseResult.accept(false)
                        errorText.accept(error.userResponse)
                    }
                }
                .disposed(by: disposeBag)
        case .edit:
            input.rightButtonTap
                .withLatestFrom(input.commentText)
                .distinctUntilChanged()
                .flatMap { [weak self] text -> Single<Result<Comment, ResponseError>> in
                    guard let self, let comment else { return .never() }
                    return self.apiService.fetchDataWithResponseError(Router.sesac(.updateComments(self.data.classId, comment.commentId, text)))
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let comment):
                        reponseResult.accept(true)
                    case .failure(let error):
                        reponseResult.accept(false)
                        errorText.accept(error.userResponse)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return Output(course: course.asDriver(onErrorDriveWith: .empty()),
                      commentText: commentText.asDriver(onErrorJustReturn: ""),
                      validText: validText.asDriver(),
                      createButtonActive: buttonActive.asDriver(onErrorDriveWith: .empty()),
                      result: reponseResult.asDriver(onErrorJustReturn: false),
                      errorMessage: errorText.asDriver(onErrorDriveWith: .empty())
        )
    }
}
