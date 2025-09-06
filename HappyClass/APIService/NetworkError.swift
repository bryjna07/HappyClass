//
//  NetworkError.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

enum LoginError: Int, Error {
    case body = 400 // 필수값을 채워주세요
    case check // 미가입 or 비밀번호 불일치
    
    var userResponse: String {
        switch self {
        case .body:
            return "이메일과 비밀번호를 모두 입력해주세요"
        case .check:
            return "미가입이거나 비밀번호가 불일치합니다"
        }
    }
}
