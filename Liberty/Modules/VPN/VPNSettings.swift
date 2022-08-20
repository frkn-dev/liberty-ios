//
//  VPNSettings.swift
//  Liberty
//
//  Created by Yury Soloshenko on 14.08.2022.
//

import Foundation

class VPNServerSettings: NSObject {
    static let shared = VPNServerSettings()
//
//    #if DEBUG
//    let p12Password = ""
//    let vpnServerAddress = "dev.fuckrkn1.xyz"
//    let vpnRemoteIdentifier = "dev.fuckrkn1.xyz"
//    let vpnLocalIdentifier = "fuckrkn1"
//    #else
    let p12Password = ""
    let vpnServerAddress = "lt.fuckrkn1.xyz"
    let vpnRemoteIdentifier = "lt.fuckrkn1.xyz"
    let vpnLocalIdentifier = "vpnclient"
//    #endif
}
