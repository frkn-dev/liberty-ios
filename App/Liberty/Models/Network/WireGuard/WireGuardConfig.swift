//
//  WireGuardConfig.swift
//  Liberty
//
//  Created by Yury Soloshenko on 16.12.2022.
//

import Foundation

struct WireGuardConfig: Codable {
    
    // MARK: - Properties
    
    let interface: WireGuardInterface
    let peer:      WireGuardPeer
    
    enum CodingKeys: String, CodingKey {
        case interface
        case peer
    }
    
    // MARK: - Init
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        interface = try container.decode(WireGuardInterface.self, forKey: .interface)
        peer      = try container.decode(WireGuardPeer.self, forKey: .peer)
    }
}
