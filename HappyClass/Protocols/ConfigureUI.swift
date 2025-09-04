//
//  ConfigureUI.swift
//  HappyClass
//
//  Created by YoungJin on 9/4/25.
//

import Foundation

@objc protocol ConfigureUI: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}
