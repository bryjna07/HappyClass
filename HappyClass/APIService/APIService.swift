//
//  APIService.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class APIService {
    
    func fetchData<T: Decodable>(_ router: Router) -> Single<Result<T, AFError>> {
        print(#function, router)
        return Single.create { observer in
            
            AF.request(router)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        dump(value)
                        observer(.success(.success(value)))
                    case .failure(let error):
                        dump(error)
                        observer(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }

}
