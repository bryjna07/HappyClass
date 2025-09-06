//
//  UserDefaultsManager.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    @UserDefault(key: "token", defaultValue: "")
    var token: String
    
}
