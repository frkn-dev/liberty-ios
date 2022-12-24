//
//  NetworkBase.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Foundation
import Alamofire

class NetworkBase {
    
    public func requestAndParse<T: Codable>(router: Router, type: T.Type, completion: @escaping (DataResponse<T, AFError>) -> Void) {
        
        // TODO: Add logging
        
        AF.request(router).validate().responseDecodable(of: type) { response in
            completion(response)
        }
    }
}
