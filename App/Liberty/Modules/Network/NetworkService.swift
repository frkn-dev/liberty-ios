//
//  NetworkService.swift
//  Liberty
//
//  Created by Yury Soloshenko on 23.12.2022.
//

import Foundation

class NetworkService {
    
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
    
    
}
