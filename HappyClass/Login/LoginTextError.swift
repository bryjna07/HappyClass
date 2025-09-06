//
//  LoginTextError.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

enum LoginTextError: Error {
    case isEmpty
    case valid(LoginType)
    
    var errorText: String {
        switch self {
        case .isEmpty:
            return "이메일과 비밀번호를 입력해주세요"
        case .valid(let type):
            switch type {
            case .email:
                return "@ 와 .com 을 포함해주세요"
            case .password:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            }
        }
    }
}

enum LoginType {
    case email
    case password
}
