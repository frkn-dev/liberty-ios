//
//  Configuration.swift
//  Liberty
//
//  Created by Yury Soloshenko on 04.11.2022.
//

import Foundation
import TunnelKitCore
import TunnelKitWireGuard

extension WireGuard {
    
    struct Configuration {
        
        static func make(from config: WireGuardConfig, and appGroup: String) -> WireGuard.ProviderConfiguration? {
                
            var builder = try! WireGuard.ConfigurationBuilder(config.interface.key)
            builder.addresses = [config.interface.address]
            builder.dnsServers = [config.interface.dns]
            try! builder.addPeer(config.peer.pubkey,
                                 endpoint: "\(config.peer.endpoint.inet):51820")
            
            builder.addDefaultGatewayIPv4(toPeer: 0)
            
            builder.setKeepAlive(25, forPeer: 0)
            try! builder.setPreSharedKey(config.peer.psk,
                                         ofPeer: 0)
            
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration("fuckrkn1",
                                                   appGroup: appGroup,
                                                   configuration: config)
        }
    }
}
