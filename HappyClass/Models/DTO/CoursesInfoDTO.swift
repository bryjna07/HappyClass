//
//  CoursesInfoDTO.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 클래스 응답 모델
struct CoursesInfoDTO: Decodable {
    let data: [CourseDTO]
}

struct CourseDTO: Decodable {
    let classId: String
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
    let creator: ProfileDTO
    
    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case category
        case title
        case description
        case price
        case salePrice = "sale_price"
        case location, date, capacity
        case imageURL = "image_url"
        case imageURLS = "image_urls"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        classId = try container.decode(String.self, forKey: .classId)
        category = try container.decode(Int.self, forKey: .category)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        creator = try container.decode(ProfileDTO.self, forKey: .creator)
        
        price = try container.decodeIfPresent(Int.self, forKey: .price)
        salePrice = try container.decodeIfPresent(Int.self, forKey: .salePrice)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        imageURLS = try container.decodeIfPresent([String].self, forKey: .imageURLS)
        
        // 옵셔널 기본값 처리
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? "미정"
        isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
    }
}
