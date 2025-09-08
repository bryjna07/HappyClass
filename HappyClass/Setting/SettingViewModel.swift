//
//  SettingViewModel.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class SettingViewModel: BaseViewModel {
    
    let apiService: APIService
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(service: APIService) {
        self.apiService = service
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
