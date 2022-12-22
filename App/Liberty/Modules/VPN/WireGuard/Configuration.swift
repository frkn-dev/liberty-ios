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
        
        static func make(_ title: String,
                         appGroup: String,
                         clientPrivateKey: String,
                         clientAddress: [String],
                         dnsServers: [String],
                         serverPublicKey: String,
                         serverAddress: String,
                         serverPort: String,
                         allowedIP: String,
                         preSharedKey: String) -> WireGuard.ProviderConfiguration? {
                
            var builder = try! WireGuard.ConfigurationBuilder(clientPrivateKey)
            builder.addresses = clientAddress
            builder.dnsServers = dnsServers
            try! builder.addPeer(serverPublicKey, endpoint: "\(serverAddress):\(serverPort)")
            builder.addAllowedIP(allowedIP, toPeer: 0)
            try! builder.setPreSharedKey(preSharedKey, ofPeer: 0)
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration(title, appGroup: appGroup, configuration: config)
        }
    }
    
    struct TestConfiguration {
        
        static func make(appGroup: String) -> WireGuard.ProviderConfiguration? {
                
            var builder = try! WireGuard.ConfigurationBuilder("6HY+tzHiLerjY/EQjuXWZa6xboNTo2C2OOFmCnPlo3g=")
            builder.addresses = ["10.7.0.3/24"]
            builder.dnsServers = ["1.1.1.1", "1.0.0.1"]
            try! builder.addPeer("DXn0oXV5/5fCtgKlf9VjqKkECX/wibquJYX6/9wCASM=",
                                 endpoint: "94.176.238.220:51820")
            
            builder.addDefaultGatewayIPv4(toPeer: 0)
            
            builder.setKeepAlive(25, forPeer: 0)
            try! builder.setPreSharedKey("Ahd1q8THNeZhfCKeHLsHZiv9OjZMxYvDo8aszEZ0fBI=",
                                         ofPeer: 0)
            
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration("fuckrkn1",
                                                   appGroup: appGroup,
                                                   configuration: config)
        }
    }
}
