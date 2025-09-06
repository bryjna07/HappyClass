//
//  Category.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

enum Category: Int, CaseIterable {
    case develope = 101
    case design
    case laguage = 201
    case life
    case beauty
    case investment = 301
    case etc = 900
    
    var name: String {
        switch self {
        case .develope:
            return "개발"
        case .design:
            return "디자인"
        case .laguage:
            return "외국어"
        case .life:
            return "라이프"
        case .beauty:
            return "뷰티"
        case .investment:
            return "재테크"
        case .etc:
            return "기타"
        }
    }
}
