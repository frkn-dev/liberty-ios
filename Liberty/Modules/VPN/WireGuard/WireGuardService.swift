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
    
    private let tunnelIdentifier = ""
    private let appGroup = ""
    
    private let vpn = NetworkExtensionVPN()
    var vpnStatus: VPNStatus = .disconnected
    
    // MARK: - Init
    
    init() {
        
        Task { await vpn.prepare() }
    }
    
    // MARK: - VPN
    
    public func connectVPN() {

        guard let config = WireGuard.TestConfiguration.make(appGroup: appGroup) else {
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
