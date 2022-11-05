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
                         clientAddress: String,
                         serverPublicKey: String,
                         serverAddress: String,
                         serverPort: String) -> WireGuard.ProviderConfiguration? {
                
            var builder = try! WireGuard.ConfigurationBuilder(clientPrivateKey)
            builder.addresses = [clientAddress]
            builder.dnsServers = ["1.1.1.1", "1.0.0.1"]
            try! builder.addPeer(serverPublicKey, endpoint: "\(serverAddress):\(serverPort)")
            builder.addAllowedIP("0.0.0.0/0, ::/0", toPeer: 0)
            try! builder.setPreSharedKey("ve+HQl9x0ypTEt1UL5LDhcZFrhgPnvY/3Iz7I52qVnQ=", ofPeer: 0)
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration(title, appGroup: appGroup, configuration: config)
        }
    }
}
