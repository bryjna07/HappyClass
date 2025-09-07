//
//  CommentListViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentListViewController: BaseViewController {
    
    private let commentListView = CommentListView()
    private let viewModel : CommentListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: CommentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = commentListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
    }
    
    private func bind() {
        
        let input = CommentListViewModel.Input(viewDidLoad: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.navTitle
            .drive(with: self) { owner, value in
                owner.navigationItem.title = value
            }
            .disposed(by: disposeBag)

        output.list
            .drive(commentListView.tableView.rx.items(
                cellIdentifier: CommentListCell.identifier,
                cellType: CommentListCell.self)) { (row, element, cell) in
                    cell.configure(with: element)
                    
                    cell.editButton.rx.tap
                        .subscribe(with: self) { owner, _ in
                            owner.sheet()
                        }
                        .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func sheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "댓글 수정", style: .default) { [weak self] _ in
        }
        let delete = UIAlertAction(title: "댓글 삭제", style: .destructive) { [weak self] _ in
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}
