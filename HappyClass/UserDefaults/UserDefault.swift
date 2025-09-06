//
//  UserDefault.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
  private let key: String
  private let defaultValue: T
  
  var wrappedValue: T {
    get {
      UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
}
