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
    "com.nezavisimost.Liberty.Soloshenko.macOSWireGuardNetworkExtension"
    #elseif os(iOS)
    private let tunnelIdentifier =
    "com.nezavisimost.Liberty.Soloshenko.iOSWireGuardNetworkExtension"
    #endif
    
    private let appGroup         = "group.vpn.nezavisimost.Soloshenko"
    
    private let networkService   = NetworkService.shared
    
    private let vpn = NetworkExtensionVPN()
    var vpnStatus: VPNStatus = .disconnected
    
    private var tryCount = 0
    
    // MARK: - Init
    
    init() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNDidFail(notification:)),
            name: VPNNotification.didFail,
            object: nil
        )
        
        Task { await vpn.prepare() }
    }
    
    // MARK: - VPN
    
    public func connectVPN() {
        
        var peerConfig: WireGuardConfig?
        
        let needsNewConfig = tryCount >= 4
        tryCount = needsNewConfig ? 0 : tryCount
        
        let group = DispatchGroup()
        group.enter()
        
        if let oldConfig = Defaults.ConnectionData.wireGuardConfig, !needsNewConfig {
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
    
    // MARK: - Action
    
    @objc private func VPNDidFail(notification: Notification) {
        tryCount += 1
        connectVPN()
    }
}
