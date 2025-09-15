//
//  ResponseDTO.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 에러 응답 모델
struct ResponseDTO: Decodable {
    let message: String?
    let likeStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case message
        case likeStatus = "like_status"
    }
}
