//
//  CategoryButton.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit

final class CategoryButton: UIButton {
    
    let category: Category?
    
    override var isSelected: Bool {
        didSet {
            changeColor()
        }
    }
    
    init(category: Category? = nil) {
        self.category = category
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        if let category {
            config.title = category.name
        } else {
            config.title = "전체"
        }
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.cornerStyle = .capsule
        config.background.strokeColor = .disSelected
        config.background.strokeWidth = 1
        config.baseForegroundColor = .disSelected
        config.baseBackgroundColor = .white
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeColor() {
        guard var config = configuration else { return }
        config.baseForegroundColor = isSelected ? .mainOrange : .disSelected
        config.background.strokeColor = isSelected ? .mainOrange : .disSelected
        self.configuration = config
    }
}
