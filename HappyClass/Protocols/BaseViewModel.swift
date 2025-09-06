//
//  BaseViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
