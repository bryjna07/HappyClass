//
//  SceneDelegate.swift
//  HappyClass
//
//  Created by YoungJin on 9/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let apiService = APIService()
        let token = UserDefaultsManager.shared.token
        
        if !token.isEmpty {
            let vc = TabBarController(service: apiService)
            window?.rootViewController = vc
        } else {
            let vm = LoginViewModel(service: apiService)
            let vc = LoginViewController(viewModel: vm)
            window?.rootViewController = vc
        }
        window?.makeKeyAndVisible()
    }

    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.rootViewController = vc
            }
        } else {
            window.rootViewController = vc
        }
    }

}

