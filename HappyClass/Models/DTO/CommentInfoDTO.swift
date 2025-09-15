//
//  CommentInfoDTO.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

struct CommentInfoDTO: Decodable {
    let data: [CommentDTO]
    enum CodingKeys: CodingKey {
        case data
    }
}

struct CommentDTO: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator : ProfileDTO
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt = "created_at"
        case creator
    }
}
