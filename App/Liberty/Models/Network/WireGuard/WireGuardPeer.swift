//
//  WireGuardPeer.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Foundation
import SwiftyJSON

struct WireGuardPeer: JSONInitializable, Codable {
    
    // MARK: - Properties
    
    let pubkey:      String
    let psk:         String
    let allowed_ips: String
    let endpoint:    String
    
    enum CodingKeys: String, CodingKey {
        case pubkey
        case psk
        case allowed_ips
        case endpoint
    }
    
    // MARK: - Init
    
    init?(json: JSON) {
        guard json.isNotEmpty else { return nil }
        guard
            let pubkey      = json["pubkey"].string,
            let psk         = json["psk"].string,
            let allowed_ips = json["allowed_ips"].string,
            let endpoint    = json["endpoint"].string
        else {
            // TODO: Add logging
            return nil
        }
        self.pubkey      = pubkey
        self.psk         = psk
        self.allowed_ips = allowed_ips
        self.endpoint    = endpoint
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pubkey      = try container.decode(String.self, forKey: .pubkey)
        psk         = try container.decode(String.self, forKey: .psk)
        allowed_ips = try container.decode(String.self, forKey: .allowed_ips)
        endpoint    = try container.decode(String.self, forKey: .endpoint)
    }
}
