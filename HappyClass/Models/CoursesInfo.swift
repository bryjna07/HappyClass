//
//  CoursesInfo.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 클래스 응답 모델
struct CoursesInfo: Decodable {
    let data: [Courses]
}

struct Courses: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let imageURL: String
    let createdAt: String
    let isLiked: Bool
    let creator: Profile
    
    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case category
        case title
        case description
        case price
        case salePrice = "sale_price"
        case imageURL = "image_url"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }
}
