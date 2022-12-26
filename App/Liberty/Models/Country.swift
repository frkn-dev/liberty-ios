//
//  Countries.swift
//  Liberty
//
//  Created by Yury Soloshenko on 23.12.2022.
//

import Foundation

enum Country: String {
    
    case russia        = "RU"
    case ukraine       = "UA"
    case netherlands   = "NL"
    case latvia        = "LT"
    case lithuania     = "LV"
    case unitedKingdom = "UK"
    case usa           = "USA"
    
    
    var description: String {
        
        switch self {
            
        case .russia:        return "🇷🇺 " + String(localized: "country.russia")
        case .ukraine:       return "🇺🇦 " + String(localized: "country.ukraine")
        case .netherlands:   return "🇳🇱 " + String(localized: "country.netherlands")
        case .latvia:        return "🇱🇻 " + String(localized: "country.latvia")
        case .lithuania:     return "🇱🇹 " + String(localized: "country.lithuania")
        case .unitedKingdom: return "🇬🇧 " + String(localized: "country.unitedKingdom")
        case .usa:           return "🇺🇸 " + String(localized: "country.usa")
        }
    }
}
