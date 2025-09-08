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
    case unknwon = 503
    
    var userResponse: String {
        switch self {
        case .body:
            return "이메일과 비밀번호를 모두 입력해주세요"
        case .check:
            return "미가입이거나 비밀번호가 불일치합니다"
        case .unknwon:
            return "알 수 없는 에러입니다"
        }
    }
}

enum ResponseError: Int, Error {
    case body = 400 // 필수값을 채워주세요
    case token = 401 // 토큰 에러
    case forbidden = 403 // 접근 권한
    case notFind = 410 // 클래스 or 댓글 없음
    case notAuthority = 445
    case unknwon = 503
    
    var userResponse: String {
        switch self {
        case .body:
            return "잘못된 글자입니다"
        case .token:
            return "유효하지 않은 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .notFind:
            return "클래스 또는 댓글을 찾을 수 없습니다"
        case .notAuthority:
            return "작성자만 가능합니다"
        case .unknwon:
            return "알 수 없는 에러입니다"
        }
    }
}
