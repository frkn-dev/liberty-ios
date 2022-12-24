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
    
    // MARK: - Singleton
    
    static let shared = WireGuardService()
    
    // MARK: - Properties
    
    #if os(macOS)
    private let tunnelIdentifier =
    "com.nezavisimost.Liberty.Soloshenko.WireGuard-Network-Extension.macOS"
    #elseif os(iOS)
    private let tunnelIdentifier =
    "com.nezavisimost.Liberty.Soloshenko.Network-Extension.iOS"
    #endif
    
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
        
        var peerConfig: WireGuardConfig?
        
        let group = DispatchGroup()
        group.enter()
        
        if let oldConfig = Defaults.ConnectionData.wireGuardConfig {
            peerConfig = oldConfig
            group.leave()
        } else {
            networkService.getPeer() { result in
                
                guard let connectionInfo = result.value else {
                    self.disconnectVPN()
                    return
                }
                
                peerConfig = connectionInfo
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            guard let peerConfig,
                  let config = WireGuard.Configuration.make(from: peerConfig, and: self.appGroup) else {
                self.disconnectVPN()
                return
            }
            
            Defaults.ConnectionData.wireGuardConfig = peerConfig
            
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
