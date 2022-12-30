//
//  NetworkBase.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Foundation
import SwiftyJSON
import Alamofire

class NetworkBase {
    
    public func requestAndParse<T: JSONInitializable>(router: Router, type: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        
        // TODO: Add logging
        
        AF.request(router).validate().responseData { response in
            
            switch response.result {
                case .failure(let error):
                    // TODO: Add logging
                    let error = AFError.responseValidationFailed(reason: .dataFileNil)
                    let result = Result<T, AFError>.failure(error)
                    completion(result)
                case .success(let value):
                    let json = JSON(value)
                    guard let structuredData = T(json:json) else {
                        // TODO: Add logging
                        let error = AFError.responseSerializationFailed(reason: .inputFileNil)
                        let result = Result<T, AFError>.failure(error)
                        completion(result)
                        return
                    }
                    let result = Result<T, AFError>.success(structuredData)
                    completion(result)
            }
        }
    }
    
    public func requestAndParseArray<T: JSONInitializable>(router: Router, type: T.Type, completion: @escaping (Result<[T], AFError>) -> Void) {
        
        AF.request(router).validate().responseData { response in
            
            switch response.result {
            case .failure(let error):
                // TODO: Add logging
                let error = AFError.responseValidationFailed(reason: .dataFileNil)
                let result = Result<[T], AFError>.failure(error)
                completion(result)
            case .success(let value):
                guard let jsonArray = JSON(value).array else {
                    // TODO: Add logging
                    let error = AFError.responseSerializationFailed(reason: .inputFileNil)
                    let result = Result<[T], AFError>.failure(error)
                    completion(result)
                    return
                }
                let items = jsonArray.compactMap { T(json:$0) }
                
                guard items.isNotEmpty else {
                    // TODO: Add logging
                    let error = AFError.responseSerializationFailed(reason: .inputFileNil)
                    let result = Result<[T], AFError>.failure(error)
                    completion(result)
                    return
                }
                let result = Result<[T], AFError>.success(items)
                completion(result)
            }
        }
    }
}
