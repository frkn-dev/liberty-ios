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
    
    // MARK: - Dependencies
    
    private var keysService = KeysService.shared
    
    // MARK: - Functions
    
    public func getPeer(for countryCode: String,
                        completion: @escaping (Result<WireGuardConfig, AFError>) -> Void) {
        
        let parameters: Parameters = [
            "location" : countryCode,
            "pubkey"   : keysService.publicKey
        ]
        
        let request = Router.getPeer(parameters: parameters)
        requestAndParse(router: request, type: WireGuardConfig.self, completion: completion)
    }
    
    public func getLocations(completion: @escaping (Result<[Country], AFError>) -> Void) {
        
        let request = Router.getLocations
        requestAndParseArray(router: request, type: Country.self, completion: completion)
    }
}
