//
//  WireGuardInterface.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Foundation

struct WireGuardInterface: Codable {
    
    // MARK: - Properties
    
    let address: String
    let key:     String
    let dns:     String
    
    enum CodingKeys: String, CodingKey {
        case address
        case key
        case dns
    }
    
    // MARK: - Init
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        address = try container.decode(String.self, forKey: .address)
        key     = try container.decode(String.self, forKey: .key)
        dns     = try container.decode(String.self, forKey: .dns)
    }
}
