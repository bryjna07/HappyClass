//
//  TabBarController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then

final class TabBarController: UITabBarController {
    
    private let apiService: APIService
    
    init(service: APIService) {
        self.apiService = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        
        let mainVM = MainViewModel(service: apiService)
        let mainVC = MainViewController(viewModel: mainVM)
        let first = UINavigationController(rootViewController: mainVC).then {
            $0.tabBarItem = UITabBarItem(
                title: "카테고리",
                image: UIImage(systemName: "house.fill"),
                tag: 0
            )
        }
        
        let searchVM = SearchViewModel(service: apiService)
        let searchVC = SearchViewController(viewModel: searchVM)
        let second = UINavigationController(rootViewController: searchVC).then {
            $0.tabBarItem = UITabBarItem(
                title: "검색",
                image: UIImage(systemName: "magnifyingglass"),
                tag: 1
            )
        }
        
        let settingVM = SettingViewModel(service: apiService)
        let settingVC = SettingViewController(viewModel: settingVM)
        let third = UINavigationController(rootViewController: settingVC).then {
            $0.tabBarItem = UITabBarItem(
                title: "설정",
                image: UIImage(systemName: "person.fill"),
                tag: 2
            )
        }
        
        setViewControllers([first, second, third,], animated: false)
    }
    
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.selected.iconColor = .navy
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.navy]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .mainGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.mainGray]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
