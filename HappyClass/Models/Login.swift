//
//  Login.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

// 로그인 응답 모델
struct Login: Decodable {
    let userId: String
    let nick: String
    let email: String
    let profileImage: String?
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case email
        case profileImage
        case accessToken
    }
}
