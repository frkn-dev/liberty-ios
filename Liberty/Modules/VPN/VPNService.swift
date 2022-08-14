//
//  VPNService.swift
//  Liberty
//
//  Created by Yury Soloshenko on 03.08.2022.
//

import NetworkExtension

class VPNService {
    
    // MARK: - Properties
    
    static let shared = VPNService()
    
    private let vpnManager = NEVPNManager.shared()
    
    // MARK: - VPN
    
    public func connectVPN() {
        initVPNTunnelProviderManager()
    }
    
    public func disconnectVPN() {
        vpnManager.connection.stopVPNTunnel()
    }
    
    public func testConnect() {
        
        do {
            try vpnManager.connection.startVPNTunnel()
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Tunnel Manager init
    
    func initVPNTunnelProviderManager() {
        
        vpnManager.loadFromPreferences { [weak self] error in
            guard let self = self,
                  error == nil else {
                print("VPN Preferences error: 1 - \(String(describing: error))")
                return
            }
            
            self.vpnManager.isEnabled = true
            self.vpnManager.protocolConfiguration = self.makeProtocolConfig()
            self.vpnManager.localizedDescription = "IKEv2 VPN lt.fuckrkn1.xyz"
            
            print("SAVE TO PREFERENCES...")
            
            self.vpnManager.saveToPreferences(completionHandler: { (error) -> Void in
                guard error == nil else {
                    print("VPN Preferences error: 2 - \(String(describing: error))")
                    return
                }
                
                print("CALL LOAD TO PREFERENCES AGAIN...")
                self.vpnManager.loadFromPreferences(completionHandler: { error in
                    guard error == nil else {
                        print("VPN Preferences error: 2 - \(String(describing: error))")
                        return
                    }
                    
                    var startError: NSError?
                    
                    do {
                        try self.vpnManager.connection.startVPNTunnel()
                    } catch let error as NSError {
                        startError = error
                        print(startError.debugDescription)
                    } catch {
                        print("Fatal Error")
                        fatalError()
                    }
                    
                    guard startError == nil else {
                        print("VPN Preferences error: 3 - \(String(describing: error))")
                        print("title: Oops.., message: Something went wrong while connecting to the VPN. Please try again.")
                        print(startError.debugDescription)
                        return
                    }
                    
                    print("Starting VPN...")
                })
            })
        }
    }
    
    // MARK: - .P12
    
    func dataFromFile() -> Data? {
        guard let rootCertPath = Bundle.main.url(forResource: "vpnclient", withExtension: "p12") else { return nil }
        
        return try? Data(contentsOf: rootCertPath.absoluteURL)
    }
    
    // MARK: - Configuring
    
    private func makeProtocolConfig() -> NEVPNProtocolIKEv2 {
        
        let vpnProtocol = NEVPNProtocolIKEv2()
        
        vpnProtocol.authenticationMethod = .certificate
        vpnProtocol.serverAddress = VPNServerSettings.shared.vpnServerAddress
        vpnProtocol.remoteIdentifier = VPNServerSettings.shared.vpnRemoteIdentifier
        vpnProtocol.localIdentifier = VPNServerSettings.shared.vpnLocalIdentifier
        
        vpnProtocol.useExtendedAuthentication = false
        vpnProtocol.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
        vpnProtocol.ikeSecurityAssociationParameters.diffieHellmanGroup = .group14
        vpnProtocol.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA256
        vpnProtocol.ikeSecurityAssociationParameters.lifetimeMinutes = 1410
        
        vpnProtocol.childSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES128GCM
        vpnProtocol.childSecurityAssociationParameters.diffieHellmanGroup = .group14
        vpnProtocol.childSecurityAssociationParameters.integrityAlgorithm = .SHA96
        vpnProtocol.childSecurityAssociationParameters.lifetimeMinutes = 1410
        
        vpnProtocol.disableRedirect = true
        
        vpnProtocol.serverCertificateIssuerCommonName = VPNServerSettings.shared.vpnServerCertificateIssuerCommonName
        vpnProtocol.certificateType = .RSA
        vpnProtocol.identityDataPassword = VPNServerSettings.shared.p12Password
        vpnProtocol.identityData = self.dataFromFile()
        
        return vpnProtocol
    }
}
