//
//  LoginView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class LoginFieldView: BaseView {
    
    let label = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    let textField = UITextField().then {
        $0.borderStyle = .none
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.point.cgColor
        $0.layer.borderWidth = 1
        $0.font = .systemFont(ofSize: 12)
        $0.returnKeyType = .done
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
}

extension LoginFieldView {
    override func configureHierarchy() {
        [
            label,
            textField
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        label.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}

