//
//  WireGuardEndpoint.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Foundation

struct WireGuardEndpoint: Codable {
    
    // MARK: - Properties
    
    let inet:  String
    let inet6: String
    
    enum CodingKeys: String, CodingKey {
        case inet
        case inet6
    }
    
    // MARK: - Init
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        inet  = try container.decode(String.self, forKey: .inet)
        inet6 = try container.decode(String.self, forKey: .inet6)
    }
}
