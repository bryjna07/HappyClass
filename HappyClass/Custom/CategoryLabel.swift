//
//  CategoryLabel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit

final class CategoryLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 12)
        textColor = .mainOrange
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainOrange.cgColor
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
