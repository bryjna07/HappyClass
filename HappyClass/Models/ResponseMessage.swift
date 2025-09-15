//
//  ResponseMessage.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 에러 Domain
struct ResponseMessage {
    let message: String?
    let likeStatus: Bool?
}

// 매핑
extension ResponseDTO {
    func toDomain() -> ResponseMessage {
        return ResponseMessage(
            message: message,
            likeStatus: likeStatus)
    }
}
