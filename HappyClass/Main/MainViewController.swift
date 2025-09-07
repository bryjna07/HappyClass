//
//  MainViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
    
    private let mainView = MainView()
    private let viewModel : MainViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "클래스 조회"
        bind()
    }
    
    private func bind() {
        
        // 카테고리버튼 옵저버블
        let categoryTap = Observable.merge(
            mainView.buttons.map { btn in
                btn.rx.tap.map { btn.category }
            }
        )
        
        // 뷰모델로 넘겨줄 카테고리
        let selectedCategories = BehaviorRelay<Set<Category>>(value: [])
        
        // 좋아요 버튼탭
        let likeTap = PublishRelay<(String, Bool)>()

        categoryTap
            .subscribe(with: self) { owner, category in
                if let category {
                    var set = selectedCategories.value
                    if set.contains(category) {
                        set.remove(category)
                    } else {
                        set.insert(category)
                    }
                    selectedCategories.accept(set)
                } else {
                    selectedCategories.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        // 버튼 UI 바인딩
        selectedCategories
            .bind(with: self) { owner, categories in
                owner.mainView.buttons.forEach { button in
                    if let category = button.category {
                        button.isSelected = categories.contains(category)
                    } else {
                        button.isSelected = categories.isEmpty
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 뷰모델로 넘겨줄 Sort
        let sortRelay = BehaviorRelay<Sort>(value: .latest)

        mainView.sortButton.rx.tap
            .withLatestFrom(sortRelay)
            .map { $0 == .latest ? .price : .latest }
            .bind(to: sortRelay)
            .disposed(by: disposeBag)

        // Sort 버튼 UI 바인딩
        sortRelay
            .map { $0.title }
            .bind(to: mainView.sortButton.rx.title())
            .disposed(by: disposeBag)

        let input = MainViewModel.Input(
            viewDidLoad: Observable.just(()),
            selectedCategories: selectedCategories.asObservable(),
            selectedSort: sortRelay.asObservable(),
            likeTap: likeTap.asObservable()
        )
        
        let output = viewModel.transform(input: input)

        // 테이블뷰 바인딩
        output.courses
            .drive(mainView.tableView.rx.items(
                cellIdentifier: MainCell.identifier,
                cellType: MainCell.self)) { (row, element, cell) in
                    cell.configure(with: element)
                    
                    cell.likeButton.rx.tap
                        .map {
                            (element.classId, !element.isLiked)
                        }
                        .bind(to: likeTap)
                        .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        // 총 갯수 표시 바인딩
        output.amountText
            .drive(mainView.amountCountLabel.rx.text)
            .disposed(by: disposeBag)

    }
}
