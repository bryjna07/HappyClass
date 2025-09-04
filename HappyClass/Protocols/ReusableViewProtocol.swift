//
//  ReusableViewProtocol.swift
//  HappyClass
//
//  Created by YoungJin on 9/4/25.
//

import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
}
