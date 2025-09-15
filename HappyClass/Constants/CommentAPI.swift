//
//  CommentAPI.swift
//  HappyClass
//
//  Created by YoungJin on 9/15/25.
//

import Foundation
import Alamofire

enum CommentAPI {
    case createComments(String, String)
    case readComments(String)
    case updateComments(String, String, String)
    case deleteComments(String, String)
    
    var method: HTTPMethod {
        switch self {
        case .createComments:
            return .post
        case .readComments:
            return .get
        case .updateComments:
            return .put
        case .deleteComments:
            return .delete
        }
    }
    
    private var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "SesacKey") as? String
    }
    
    private var token: String {
        return UserDefaultsManager.shared.token
    }
    
    var headers: HTTPHeaders {
        guard let key = apiKey else {
            fatalError("API 키가 설정되지 않았습니다.")
        }
        switch self {
        case .readComments, .deleteComments:
            return [
                "Authorization": "\(token)",
                "SesacKey": "\(key)"
            ]
        case .createComments, .updateComments:
            return [
                "Authorization": "\(token)",
                "Content-Type": "application/json",
                "SesacKey": "\(key)"
            ]
        }
    }
    
    var path: String {
        switch self {
        case .createComments(let id, _), .readComments(let id):
            return "/v1/courses/\(id)/comments"
        case .updateComments(let id, let commentID, _), .deleteComments(let id, let commentID):
            return "/v1/courses/\(id)/comments/\(commentID)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .readComments, .deleteComments:
            return nil
        case .createComments(_, let content), .updateComments(_, _, let content):
            return [
                "content": content
            ]
        }
    }
}
