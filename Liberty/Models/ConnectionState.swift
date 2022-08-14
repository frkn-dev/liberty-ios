//
//  ConnectionState.swift
//  Liberty
//
//  Created by Yury Soloshenko on 14.08.2022.
//

import Foundation
import NetworkExtension

public enum ConnectionState: String {
    
    case disconnected = "Disconnected"
    case connecting = "Connecting"
    case connected = "Connected"
    
    init?(_ state: NEVPNStatus) {
        
        switch state {
        case NEVPNStatus.connected:
            self = .connected
        case NEVPNStatus.invalid, NEVPNStatus.disconnecting, NEVPNStatus.disconnected :
            self = .disconnected
        case NEVPNStatus.connecting , NEVPNStatus.reasserting:
            self = .connecting
        default:
            return nil
        }
    }
}
