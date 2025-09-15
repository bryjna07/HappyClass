//
//  CommentList.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 댓글 domain
struct CommentList {
    let data: [Comment]
}

struct Comment {
    let id: String
    let content: String
    let createdAt: String
    let creator: UserProfile
}

// 매핑
extension CommentInfoDTO {
    func toDomain() -> CommentList {
        return CommentList(data: data.map { $0.toDomain() } )
    }
}

extension CommentDTO {
    func toDomain() -> Comment {
        return Comment(
            id: commentId,
            content: content,
            createdAt: DateFormatManager.shared.commentDisplayFormat(dateString: createdAt),
            creator: creator.toDomain()
        )
    }
}
