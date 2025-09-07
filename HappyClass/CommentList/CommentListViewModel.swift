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
    private let title: String?
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let list: Driver<[Comment]>
        let navTitle: Driver<String?>
    }
    
    init(service: APIService, data: [Comment], title: String?) {
        self.apiService = service
        self.data = data
        self.title = title
    }
    
    func transform(input: Input) -> Output {
        
        let comments = BehaviorRelay<[Comment]>(value: [])
        let title = BehaviorRelay<String?>(value: nil)
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                comments.accept(owner.data)
                title.accept(owner.title)
            }
            .disposed(by: disposeBag)
        
        return Output(list: comments.asDriver(), navTitle: title.asDriver())
    }
}
