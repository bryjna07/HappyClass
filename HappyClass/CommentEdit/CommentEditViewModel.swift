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
        let rightButtonTap: Observable<String>
    }
    
    struct Output {
        let course: Driver<Course>
        let validText: Driver<String>
        let result: Driver<Bool>
    }
    
    init(service: APIService, data: Course, comment: Comment? = nil, type: EditType) {
        self.apiService = service
        self.data = data
        self.comment = comment
        self.type = type
    }
    
    func transform(input: Input) -> Output {
        
        let course = BehaviorRelay<Course>(value: data)
        let validText = BehaviorRelay(value: "0 / 300")
        let reponseResult = PublishRelay<Bool>()
        
        switch type {
        case .create:
            input.rightButtonTap
                .flatMap { [weak self] text -> Single<Result<Comment, AFError>> in
                    guard let self else { return .never() }
                    return self.apiService.fetchData(Router.sesac(.createComments(self.data.classId, text)))
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let comment):
                        dump(comment)
                        reponseResult.accept(true)
                    case .failure(let error):
                        reponseResult.accept(false)
                        print(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
        case .edit:
            input.rightButtonTap
                .flatMap { [weak self] text -> Single<Result<Comment, AFError>> in
                    guard let self, let comment else { return .never() }
                    return self.apiService.fetchData(Router.sesac(.updateComments(self.data.classId, comment.commentId, text)))
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let comment):
                        dump(comment)
                        reponseResult.accept(true)
                    case .failure(let error):
                        reponseResult.accept(false)
                        print(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return Output(course: course.asDriver(onErrorDriveWith: .empty()),
                      validText: validText.asDriver(),
                      result: reponseResult.asDriver(onErrorJustReturn: false)
        )
    }
}
