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
        
        static func make(from config: WireGuardConfig) -> WireGuard.ProviderConfiguration? {
                
            var builder = try! WireGuard.ConfigurationBuilder(config.interface.key)
            builder.addresses = config.interface.address.components(separatedBy: ",")
            builder.dnsServers = config.interface.dns.components(separatedBy: ",")
            try! builder.addPeer(config.peer.pubkey,
                                 endpoint: config.peer.endpoint)
            
            config.peer.allowed_ips.components(separatedBy: ",").forEach {
                builder.addAllowedIP($0, toPeer: 0)
            }
            
            builder.setKeepAlive(25, forPeer: 0)
            try! builder.setPreSharedKey(config.peer.psk,
                                         ofPeer: 0)
            
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration("fuckrkn1",
                                                   appGroup: appGroup,
                                                   configuration: config)
        }
    }
    
    struct TestConfiguration {
        
        static func make() -> WireGuard.ProviderConfiguration? {
                
            var builder = try! WireGuard.ConfigurationBuilder("IH3WHTfF0R+ehS5q+I/14NVibmDJGKwmtx/KxeDBn2A=")
            builder.addresses = ["10.7.0.2/24"]
            builder.dnsServers = ["1.1.1.1", "1.0.0.1"]
            try! builder.addPeer("DXn0oXV5/5fCtgKlf9VjqKkECX/wibquJYX6/9wCASM=",
                                 endpoint: "94.176.238.220:51820")
            
            builder.addDefaultGatewayIPv4(toPeer: 0)
            
            builder.setKeepAlive(25, forPeer: 0)
            try! builder.setPreSharedKey("WCmLsc3sH6iCQ689P/hk42JLXz+5jSjvF9is3/CYHzQ=",
                                         ofPeer: 0)
            
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration("fuckrkn1",
                                                   appGroup: appGroup,
                                                   configuration: config)
        }
    }
}
