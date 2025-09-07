//
//  DateFormatManager.swift
//  HappyClass
//
//  Created by YoungJin on 9/7/25.
//

import UIKit

struct DateFormatManager {
    static let shared = DateFormatManager()
    private init() {}
 
    private let formatter = DateFormatter()

    func detailDisplayFormat(dateString: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy년 MM월 dd일 a h시 mm분"
            formatter.amSymbol = "오전"
            formatter.pmSymbol = "오후"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func commentDisplayFormat(dateString: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yy년 MM월 dd일 a h시 mm분"
            formatter.amSymbol = "오전"
            formatter.pmSymbol = "오후"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
}
