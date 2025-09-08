//
//  SettingViewController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController {
    
    private let settingView = SettingView()
    private let viewModel : SettingViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        let titleLabel = UILabel()
        titleLabel.text = "프로필"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .navy
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}
