//
//  CategoryLabelView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class CategoryLabelView: BaseView {
    
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .mainOrange
        $0.textAlignment = .center
    }
    
    init() {
        super.init(frame: .zero)
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainOrange.cgColor
        layer.cornerRadius = 4
        clipsToBounds = true
    }
}

extension CategoryLabelView {
    override func configureHierarchy() {
        addSubview(label)
    }
    
    override func configureLayout() {
        
        label.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(2)
            $0.horizontalEdges.equalToSuperview().inset(4)
        }
    }
}
