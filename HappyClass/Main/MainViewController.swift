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
        
        let input = MainViewModel.Input(viewDidLoad: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.courses
            .drive(mainView.tableView.rx.items(
                cellIdentifier: MainCell.identifier,
                cellType: MainCell.self)
            ) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)

    }
}
