//
//  MainView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class MainView: BaseView {
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
    }
    
    let buttons: [CategoryButton] = {
        let cats = Category.allCases.map { CategoryButton(category: $0) }
        let all = CategoryButton()
        return [all] + cats
    }()
    
    private lazy var categoryStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    
    let amountCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    let sortButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "line.3.horizontal")
        config.imagePlacement = .trailing
        config.baseForegroundColor = .mainOrange
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        $0.configuration = config
    }
    
    let tableView = UITableView().then {
        $0.register(MainCell.self, forCellReuseIdentifier: MainCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
}

extension MainView {
    
    override func configureHierarchy() {

        buttons.forEach {
            categoryStack.addArrangedSubview($0)
        }
        
        scrollView.addSubview(categoryStack)
        
        [
            scrollView,
            amountCountLabel, sortButton,
            tableView
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {

        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview()
        }
       
        categoryStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide.snp.height)
        }

        amountCountLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(amountCountLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
