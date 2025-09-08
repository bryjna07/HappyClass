//
//  CommentEditView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class CommentEditView: BaseView {
    
    private let categoryLabel = CategoryLabel()
    
    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .navy
    }
    
    let textView = UITextView().then {
        $0.font = .systemFont(ofSize: 14)
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.clipsToBounds = true
    }
    
    let validLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
}

extension CommentEditView {
    
    override func configureHierarchy() {
        [
            categoryLabel,
            nameLabel,
            textView,
            validLabel
        ].forEach {
            addSubview($0)
        }
        
    }
    
    override func configureLayout() {
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(240)
        }
        
        validLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with data: Course) {
        
        categoryLabel.text = Category(rawValue: data.category)?.name
        nameLabel.text = data.title
    }
}
