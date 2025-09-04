//
//  BaseView.swift
//  HappyClass
//
//  Created by YoungJin on 9/4/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseView: ConfigureUI {
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() {
        backgroundColor = .white
    }
}
