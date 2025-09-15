//
//  UserProfile.swift
//  HappyClass
//
//  Created by YoungJin on 9/15/25.
//

import Foundation

// 프로필 Domain
struct UserProfile {
    let userId: String
    let nickname: String
    let email: String?
    let profileImagePath: String?
}

// 매핑
extension ProfileDTO {
    func toDomain() -> UserProfile {
        return UserProfile(
            userId: userId,
            nickname: nick,
            email: email,
            profileImagePath: profileImage
        )
    }
}
