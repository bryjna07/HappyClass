//
//  CoursesList.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 클래스 domain
struct CoursesList {
    let data: [Course]
}

struct Course {
    let id: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let location: String?
    let date: String?
    let capacity: Int?
    let imageURL: String?
    let imageURLS: [String]?
    let createdAt: String
    let isLiked: Bool
    let creator: UserProfile
}

extension Course {
    
    var dicountPercent: String {
        guard let price, let salePrice else {
            return ""
        }
        let num = 1.0 - (Double(salePrice) / Double(price))
        let percent = Int((num * 100).rounded())
        return "\(percent)%"
    }
    
    var priceString: String {
        if let price {
            return "\(price.formatted())원"
        } else {
            return "무료"
        }
    }
    
    var capacityString: String {
        if let capacity {
            return "\(capacity)명"
        } else {
            return "미정"
        }
    }
}

// 매핑
extension CoursesInfoDTO {
    func toDomain() -> CoursesList {
        return CoursesList(data: data.map { $0.toDomain() } )
    }
}

extension CourseDTO {
    func toDomain() -> Course {
        return Course(
            id: classId,
            category: category,
            title: title,
            description: description,
            price: price,
            salePrice: salePrice,
            location: location,
            date: date,
            capacity: capacity,
            imageURL: imageURL,
            imageURLS: imageURLS,
            createdAt: createdAt,
            isLiked: isLiked,
            creator: creator.toDomain()
        )
    }
}
