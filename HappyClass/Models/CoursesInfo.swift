//
//  CoursesInfo.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 클래스 응답 모델
struct CoursesInfo: Decodable {
    let data: [Course]
}

struct Course: Decodable {
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
    let creator: Profile
    
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
        
        // 옵셔널 기본값 처리
        price = try container.decodeIfPresent(Int.self, forKey: .price)
        salePrice = try container.decodeIfPresent(Int.self, forKey: .salePrice)
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? "미정"
        date = try container.decodeIfPresent(String.self, forKey: .date)
        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        imageURLS = try container.decodeIfPresent([String].self, forKey: .imageURLS)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
        creator = try container.decode(Profile.self, forKey: .creator)
    }
    
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
