//
//  SettingView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class SettingView: BaseView {
    
    let logoutButton = PointButton(title: "로그아웃").then {
        $0.backgroundColor = .mainOrange
    }
    
}

extension SettingView {
    
    override func configureHierarchy() {
        addSubview(logoutButton)
    }
    
    override func configureLayout() {
        logoutButton.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
    }
}
