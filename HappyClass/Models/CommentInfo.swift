//
//  CommentInfo.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

struct CommentInfo: Decodable {
    let data: [Comment]
    enum CodingKeys: CodingKey {
        case data
    }
}

struct Comment: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator : Profile
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt = "created_at"
        case creator
    }
}
