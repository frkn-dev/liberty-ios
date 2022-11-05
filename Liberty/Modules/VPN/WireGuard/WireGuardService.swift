//
//  WireGuardService.swift
//  Liberty
//
//  Created by Yury Soloshenko on 03.08.2022.
//

import NetworkExtension
import TunnelKitManager
import TunnelKitWireGuard

class WireGuardService {
    
    // MARK: - Properties
    
    static let shared = WireGuardService()
    
    private let tunnelIdentifier = "com.nezavisimost.Liberty.Soloshenko.Network-Extension"
    private let appGroup = "com.nezavisimost.Liberty.Soloshenko"
    
    private let vpn = NetworkExtensionVPN()
    private var vpnStatus: VPNStatus = .disconnected
    
    
    
    // MARK: - Init
    
    init() {
        
        Task { await vpn.prepare() }
    }
    
    // MARK: - VPN
    
    public func connectVPN() {

        guard let config = WireGuard.Configuration.make(
            "TunnelKit.WireGuard",
            appGroup: appGroup,
            clientPrivateKey: "wBJPKf8grndmOnZH8UjdXSBIPKHhlxylMAvxwfXgNkE=",
            clientAddress: "10.7.0.2/24",
            serverPublicKey: "95XuJVa9H5n7k9FE/EQoiOpk/kJx+Tzu09pLDP/7zXo=",
            serverAddress: "94.176.238.220",
            serverPort: "51820"
        ) else {
            print("Configuration incomplete")
            return
        }

        Task {
            try await vpn.reconnect(
                tunnelIdentifier,
                configuration: config,
                extra: nil,
                after: .seconds(2)
            )
        }
    }
    
    public func disconnectVPN() {
        Task { await vpn.disconnect() }
    }
}
