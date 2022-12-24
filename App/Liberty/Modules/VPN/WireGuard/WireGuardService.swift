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
    
    private let tunnelIdentifier = "com.nezavisimost.Liberty.Soloshenko.WireGuard-Network-Extension.macOS"
    private let appGroup         = "group.vpn.nezavisimost.Soloshenko"
    
    private let networkService   = NetworkService.shared
    
    private let vpn = NetworkExtensionVPN()
    var vpnStatus: VPNStatus = .disconnected
    
    // MARK: - Init
    
    init() {
        
        Task { await vpn.prepare() }
    }
    
    // MARK: - VPN
    
    public func connectVPN() {

        networkService.getPeer() { result in
            
            guard let connectionInfo = result.value else {
                self.disconnectVPN()
                return
            }
            
            guard let config = WireGuard.Configuration.make(from: connectionInfo, and: self.appGroup) else {
                print("Configuration incomplete")
                return
            }

            Task {
                try await self.vpn.reconnect(
                    self.tunnelIdentifier,
                    configuration: config,
                    extra: nil,
                    after: .seconds(2)
                )
            }
        }
    }
    
    public func disconnectVPN() {
        Task { await vpn.disconnect() }
    }
}
