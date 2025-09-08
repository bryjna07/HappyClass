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
        bind()
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        let titleLabel = UILabel()
        titleLabel.text = "프로필"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .navy
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    private func bind() {
        settingView.logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", ok: "확인") {
                    UserDefaultsManager.shared.token = ""
                    UserDefaultsManager.shared.id = ""
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let vm = LoginViewModel(service: owner.viewModel.apiService)
                        let vc = LoginViewController(viewModel: vm)
                        sceneDelegate.changeRootViewController(vc)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert(title: String, message: String, ok: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            completion()
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
