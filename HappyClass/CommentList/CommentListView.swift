//
//  CommentListView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class CommentListView: BaseView {
    
    let tableView = UITableView().then {
        $0.register(CommentListCell.self, forCellReuseIdentifier: CommentListCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
}

extension CommentListView {
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
