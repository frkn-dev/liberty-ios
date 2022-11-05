//
//  VPNSettings.swift
//  Liberty
//
//  Created by Yury Soloshenko on 14.08.2022.
//

import Foundation

class VPNServerSettings: NSObject {
    static let shared = VPNServerSettings()

    // MARK: - IKEv2
    #if DEBUG
    let p12Password = ""
    let ikev2ServerAddress = "lt.fuckrkn1.xyz"
    let ikev2RemoteIdentifier = "lt.fuckrkn1.xyz"
    let ikev2LocalIdentifier = "vpnclient"
    #else
    let p12Password = ""
    let ikev2ServerAddress = "lt.fuckrkn1.xyz"
    let ikev2RemoteIdentifier = "lt.fuckrkn1.xyz"
    let ikev2LocalIdentifier = "vpnclient"
    #endif
    
    // MARK: - WireGuard
    
}
