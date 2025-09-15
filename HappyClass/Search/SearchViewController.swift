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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.searchBar.becomeFirstResponder()
        bind()
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        let titleLabel = UILabel()
        titleLabel.text = "클래스 검색"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .navy
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
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
        
        output.showEmptyView
            .drive(with: self) { owner, value in
                owner.searchView.emptyView.isHidden = !value.0
                owner.searchView.emptyView.label.text = value.1
            }
            .disposed(by: disposeBag)


        output.list
            .drive(searchView.tableView.rx.items(
                cellIdentifier: SearchCell.identifier,
                cellType: SearchCell.self)) { (row, element, cell) in
                    cell.configure(with: element)
                    
                    cell.likeButton.rx.tap
                        .map {
                            (element.id, !element.isLiked)
                        }
                        .bind(to: likeTap)
                        .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        searchView.tableView.rx.modelSelected(Course.self)
            .bind(with: self) { owner, course in
                let vm = DetailViewModel(service: owner.viewModel.apiService, classId: course.id)
                let vc = DetailViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, text in
                owner.view.makeToast(text, position: .bottom)
            }
            .disposed(by: disposeBag)
        
    }
    
}
