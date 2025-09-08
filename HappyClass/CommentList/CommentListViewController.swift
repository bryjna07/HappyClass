//
//  CommentListViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class CommentListViewController: BaseViewController {
    
    private let commentListView = CommentListView()
    private let viewModel : CommentListViewModel
    private let disposeBag = DisposeBag()
    private let viewWillAppearRelay = PublishRelay<Void>()
    
    init(viewModel: CommentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = commentListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.and.scribble"), style: .plain, target: nil, action: nil)
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearRelay.accept(())
    }
     
    private func bind() {
        let deleteTap = PublishRelay<Comment>()
        
        let input = CommentListViewModel.Input(viewDidLoad: .just(()),
                                               viewWillAppear: viewWillAppearRelay.asObservable(),
                                               commentDeleteTap: deleteTap.asObservable(),
        )
        
        let output = viewModel.transform(input: input)
        
        output.course
            .drive(with: self) { owner, value in
                owner.navigationItem.title = value.title
            }
            .disposed(by: disposeBag)

        output.list
            .drive(commentListView.tableView.rx.items(
                cellIdentifier: CommentListCell.identifier,
                cellType: CommentListCell.self)) { (row, element, cell) in
                    cell.configure(with: element)
                    
                    cell.editButton.rx.tap
                        .withLatestFrom(output.course)
                        .bind(with: self) { owner, value in
                            owner.actionSheet {
                                let vm = CommentEditViewModel(service: owner.viewModel.apiService, data: value, comment: element, type: .edit)
                                let vc = CommentEditViewController(viewModel: vm, type: .edit)
                                owner.navigationController?.pushViewController(vc, animated: true)
                            } onDelete: {
                                deleteTap.accept(element)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                }
                .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(output.course)
            .bind(with: self) { owner, value in
                let vm = CommentEditViewModel(service: owner.viewModel.apiService, data: value, type: .create)
                let vc = CommentEditViewController(viewModel: vm, type: .create)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, text in
                owner.view.makeToast(text, position: .bottom)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func actionSheet(onEdit: @escaping () -> Void, onDelete: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "댓글 수정", style: .default) { _ in
            onEdit()
        }
        let delete = UIAlertAction(title: "댓글 삭제", style: .destructive) { _ in
            onDelete()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}
