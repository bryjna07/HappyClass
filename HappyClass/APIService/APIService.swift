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
        return Single.create { observer in
            
            AF.request(router)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        observer(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchDataWithLoginError<T: Decodable>(_ router: Router) -> Single<Result<T, LoginError>> {
        return Single.create { observer in
            
            AF.request(router)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        let code = response.response?.statusCode ?? 500
                        let errorType = LoginError(rawValue: code) ?? .unknwon
                        observer(.success(.failure(errorType)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchDataWithResponseError<T: Decodable>(_ router: Router) -> Single<Result<T, ResponseError>> {
        return Single.create { observer in
            
            AF.request(router)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(_):
                        let code = response.response?.statusCode ?? 500
                        let errorType = ResponseError(rawValue: code) ?? .blank
                        observer(.success(.failure(errorType)))
                    }
                }
            return Disposables.create()
        }
    }

}
