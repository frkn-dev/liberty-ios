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
                
            var builder = try! WireGuard.ConfigurationBuilder("wBJPKf8grndmOnZH8UjdXSBIPKHhlxylMAvxwfXgNkE=")
            builder.addresses = ["10.7.0.2/24"]
            builder.dnsServers = ["1.1.1.1", "1.0.0.1"]
            try! builder.addPeer("95XuJVa9H5n7k9FE/EQoiOpk/kJx+Tzu09pLDP/7zXo=",
                                 endpoint: "94.176.238.220:51820")
            builder.addAllowedIP("0.0.0.0/0, ::/0", toPeer: 0)
            try! builder.setPreSharedKey("ve+HQl9x0ypTEt1UL5LDhcZFrhgPnvY/3Iz7I52qVnQ=", ofPeer: 0)
            let config = builder.build()
            
            return WireGuard.ProviderConfiguration("fuckrkn1",
                                                   appGroup: appGroup,
                                                   configuration: config)
        }
    }
}
