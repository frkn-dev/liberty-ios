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
    
    private let networkService = NetworkService.shared
    
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
        
        guard tryCount < 6 else {
            tryCount = 0
            return
        }
        
        let oldConfig = Defaults.ConnectionData.wireGuardConfig
        let needsNewConfig = tryCount == 4 || oldConfig == nil
        
        let group = DispatchGroup()
        group.enter()
        
        if needsNewConfig {
            networkService.getPeer() { result in
                if let connectionInfo = result.value {
                    peerConfig = connectionInfo
                } else {
                    self.disconnectVPN()
                }
                
                group.leave()
            }
        } else {
            peerConfig = oldConfig
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard let peerConfig,
                  let config = WireGuard.Configuration.make(from: peerConfig) else {
                self.disconnectVPN()
                return
            }
            
            Defaults.ConnectionData.wireGuardConfig = peerConfig
            
            Task {
                try await self.vpn.reconnect(
                    tunnelIdentifier,
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
