//
//  TabBarController.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        
        let apiService = APIService()
        
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
        
        appearance.stackedLayoutAppearance.selected.iconColor = .gray
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
