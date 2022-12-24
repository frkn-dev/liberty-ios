//
//  WireGuardPeer.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Foundation

struct WireGuardPeer: Codable {
    
    // MARK: - Properties
    
    let pubkey:      String
    let psk:         String
    let allowed_ips: String
    let endpoint:    WireGuardEndpoint
    
    enum CodingKeys: String, CodingKey {
        case pubkey
        case psk
        case allowed_ips
        case endpoint
    }
    
    // MARK: - Init
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pubkey      = try container.decode(String.self, forKey: .pubkey)
        psk         = try container.decode(String.self, forKey: .psk)
        allowed_ips = try container.decode(String.self, forKey: .allowed_ips)
        endpoint    = try container.decode(WireGuardEndpoint.self, forKey: .endpoint)
    }
}
