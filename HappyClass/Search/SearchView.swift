//
//  SearchView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class SearchView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력해주세요"
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: $0.searchTextField.placeholder ?? "", attributes: [.foregroundColor : UIColor.mainGray]) // 플레이스홀더 색상
        $0.searchTextField.leftView?.tintColor = .navy // 서치 아이콘 색상
        $0.backgroundColor = .white
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.font = .systemFont(ofSize: 16)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.navy.cgColor
        $0.clipsToBounds = true
    }
    
    let tableView = UITableView().then {
        $0.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        $0.rowHeight = 120
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    let emptyView = EmptyView()
    
}

extension SearchView {
    
    override func configureHierarchy() {
        [
            searchBar,
            tableView,
            emptyView
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
    }

}
