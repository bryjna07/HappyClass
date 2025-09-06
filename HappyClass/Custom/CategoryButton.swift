//
//  CategoryButton.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit

final class CategoryButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.title = title
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
    
}
