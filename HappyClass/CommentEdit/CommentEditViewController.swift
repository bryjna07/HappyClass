//
//  CommentEditViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

enum EditType {
    case create
    case edit
}

final class CommentEditViewController: BaseViewController {
    
    private let commentEditView = CommentEditView()
    private let viewModel : CommentEditViewModel
    private let disposeBag = DisposeBag()
    private let type: EditType
    
    private lazy var createButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil)
    }()
    
    init(viewModel: CommentEditViewModel, type: EditType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = commentEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .create:
            navigationItem.title = "댓글 작성"
        case .edit:
            navigationItem.title = "댓글 수정"
        }
        navigationItem.rightBarButtonItem = createButton
        bind()
    }
    
    private func bind() {
        
        let textInput = createButton.rx.tap
            .withLatestFrom(commentEditView.textView.rx.text.orEmpty.asObservable())
        
        let input = CommentEditViewModel.Input(rightButtonTap: textInput)
        
        let output = viewModel.transform(input: input)
        
        output.course
            .drive(with: self) { owner, data in
                owner.commentEditView.configure(with: data)
            }
            .disposed(by: disposeBag)
        
        output.result
            .drive(with: self) { owner, value in
                if value {
                    owner.navigationController?.popViewController(animated: true)
                } else {
                    owner.view.makeToast("댓글 업데이트 실패", position: .center)
                }
            }
            .disposed(by: disposeBag)

    }

    
    
}
