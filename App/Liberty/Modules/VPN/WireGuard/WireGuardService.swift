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
    private let countryService = CountryService.shared
    
    private let vpn = NetworkExtensionVPN()
    var vpnStatus: VPNStatus = .disconnected
    
    var observers: [VPNStatusObserver] = []
    
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
    
    public func connectVPN(needsNewConfig: Bool) {
        
        var peerConfig: WireGuardConfig?
        
        guard tryCount < 6 else {
            tryCount = 0
            return
        }
        
        let oldConfig = Defaults.ConnectionData.wireGuardConfig
        let needsNewConfig = tryCount == 4 || Defaults.ConnectionData.lastConnectedCountry != countryService.selectedCountry || oldConfig == nil || needsNewConfig
        
        let group = DispatchGroup()
        group.enter()
        
        if needsNewConfig {
            networkService.getPeer(for: countryService.selectedCountry.code) { result in
                switch result {
                case .success(let config):
                    peerConfig = config
                    Defaults.ConnectionData.wireGuardConfig = peerConfig
                case .failure:
                    self.observers.forEach { $0.disconnectedByFailure() }
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
                self.observers.forEach { $0.disconnectedByFailure() }
                return
            }
            
            Defaults.ConnectionData.lastConnectedCountry = self.countryService.selectedCountry
            
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
        
        guard let userInfo = notification.userInfo,
              let error = userInfo["Error"] as? Error,
              error.localizedDescription != "permission denied"
        else {
            observers.forEach { $0.disconnectedByFailure() }
            return
        }
        
        tryCount += 1
        connectVPN(needsNewConfig: false)
    }
}
