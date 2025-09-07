//
//  Sort.swift
//  HappyClass
//
//  Created by YoungJin on 9/7/25.
//

import Foundation

enum Sort {
    case latest
    case price

    var title: String {
        switch self {
        case .latest: 
            return "최신순"
        case .price:
            return "금액 높은 순"
        }
    }
}
