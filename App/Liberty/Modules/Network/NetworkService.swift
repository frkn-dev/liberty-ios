//
//  NetworkService.swift
//  Liberty
//
//  Created by Yury Soloshenko on 23.12.2022.
//

import Foundation
import Alamofire

class NetworkService: NetworkBase {
    
    // MARK: - Singleton
    
    public static let shared = NetworkService()
    
    // MARK: - Properties
    
    public var networkObservers: [NetworkObserver] = []
    
    public var selectedCountry: Country = .netherlands {
        didSet {
            networkObservers.forEach { $0.countryUpdated() }
        }
    }
    
    // MARK: - Functions
    
    public func getPeer(completion: @escaping (DataResponse<WireGuardConfig, AFError>) -> Void) {
        
        var parameters: Parameters = [:]
        
        let request = Router.getPeer(parameters: parameters)
        requestAndParse(router: request, type: WireGuardConfig.self, completion: completion)
    }
}
