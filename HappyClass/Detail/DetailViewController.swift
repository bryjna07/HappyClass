//
//  DetailViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    
    private let detailView = DetailView()
    private let viewModel : DetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        
        let input = DetailViewModel.Input(viewDidLoad: .just(()))
        
        let output = viewModel.transform(input: input)
        
        output.data
            .drive(with: self) { owner, data in
                owner.detailView.configure(with: data)
                owner.navigationItem.title = data.title
            }
            .disposed(by: disposeBag)
        
        output.imageList
            .drive(detailView.collectionView.rx.items(cellIdentifier: DetailCell.identifier, cellType: DetailCell.self)) { (row, element, cell) in
                cell.imageView.setKFImage(path: element)
            }
            .disposed(by: disposeBag)
    }
}
