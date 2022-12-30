//
//  CountryService.swift
//  Liberty_iOS
//
//  Created by Yury Soloshenko on 29.12.2022.
//

import Foundation

class CountryService {
    
    // MARK: - Singleton
    
    public static let shared = CountryService()
    
    // MARK: - Properties
    
    public var countryObservers: [CountryObserver] = []
    
    public var selectedCountry = Country() {
        didSet {
            countryObservers.forEach { $0.countryUpdated() }
        }
    }
    
    public var supportedCountries: [Country] = [Country()] {
        didSet {
            guard let supportedCountry = supportedCountries.first else { return }
            selectedCountry = supportedCountry
        }
    }
}
