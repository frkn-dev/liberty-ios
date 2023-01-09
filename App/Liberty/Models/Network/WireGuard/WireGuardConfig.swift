//
//  WireGuardConfig.swift
//  Liberty
//
//  Created by Yury Soloshenko on 16.12.2022.
//

import Foundation
import SwiftyJSON

struct WireGuardConfig: JSONInitializable, Codable {
    
    // MARK: - Properties
    
    let interface: WireGuardInterface
    let peer:      WireGuardPeer
    
    enum CodingKeys: String, CodingKey {
        case interface
        case peer
    }
    
    // MARK: - Init
    
    init?(json: JSON) {
        guard json.isNotEmpty else { return nil }
        guard
            let interface = WireGuardInterface(json: json["iface"]),
            let peer      = WireGuardPeer(json: json["peer"])
        else {
            // TODO: Add logging
            return nil
        }
        self.interface = interface
        self.peer      = peer
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        interface = try container.decode(WireGuardInterface.self, forKey: .interface)
        peer      = try container.decode(WireGuardPeer.self, forKey: .peer)
    }
}
