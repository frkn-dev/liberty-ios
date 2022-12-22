//
//  DeeplinkParser.swift
//  Liberty
//
//  Created by Yury Soloshenko on 10.10.2022.
//

import Foundation

class DeeplinkParser {
    
    // MARK: - Properties
    
    static let shared = DeeplinkParser()
    
    // MARK: - Dependencies
    
    var vpnService = WireGuardService.shared
    
    // MARK: - Methods
    
    public func parse(_ deeplink: URL) {
        
        switch deeplink.absoluteString {
        case "widget://connectVPN": vpnService.connectVPN()
        case "widget://disconnectVPN": vpnService.disconnectVPN()
        default: break
        }
    }
}
