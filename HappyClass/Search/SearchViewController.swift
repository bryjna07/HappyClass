//
//  SearchViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    private let viewModel : SearchViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = searchView
        navigationItem.title = "클래스 검색"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.searchBar.becomeFirstResponder()
        bind()
    }
    
    private func bind() {
        
        let likeTap = PublishRelay<(String, Bool)>()
        
        searchView.searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                owner.searchView.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        let input = SearchViewModel.Input(
            searchButtonTap: searchView.searchBar.rx.searchButtonClicked
                .withLatestFrom(searchView.searchBar.rx.text.orEmpty),
            likeTap: likeTap.asObservable()
        )
        
        let output = viewModel.transform(input: input)

        output.list
            .drive(searchView.tableView.rx.items(
                cellIdentifier: SearchCell.identifier,
                cellType: SearchCell.self)) { (row, element, cell) in
                    cell.configure(with: element)
                    
                    cell.likeButton.rx.tap
                        .map {
                            (element.classId, !element.isLiked)
                        }
                        .bind(to: likeTap)
                        .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
}
