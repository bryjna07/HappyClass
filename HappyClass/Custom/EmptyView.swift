//
//  EmptyView.swift
//  HappyClass
//
//  Created by YoungJin on 9/8/25.
//

import UIKit
import Then
import SnapKit

final class EmptyView: BaseView {
    
    let label = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .navy
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
}

extension EmptyView {
    override func configureHierarchy() {
        addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
