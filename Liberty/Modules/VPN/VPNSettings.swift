//
//  VPNSettings.swift
//  Liberty
//
//  Created by Yury Soloshenko on 14.08.2022.
//

import Foundation

class VPNServerSettings: NSObject {
    static let shared = VPNServerSettings()
    
    let p12Password = "CnKzvZujdvxU3bwBSo"
    let vpnServerAddress = "lt.fuckrkn1.xyz"
    let vpnRemoteIdentifier = "lt.fuckrkn1.xyz"
    let vpnLocalIdentifier = "vpnclient"
}
