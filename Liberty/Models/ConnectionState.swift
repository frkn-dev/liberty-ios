//
//  ConnectionState.swift
//  Liberty
//
//  Created by Yury Soloshenko on 14.08.2022.
//

import Foundation
import NetworkExtension

public enum ConnectionState: String {
    
    case disconnecting = "Disconnecting"
    case disconnected = "Disconnected"
    case connecting = "Connecting"
    case connected = "Connected"
    
    init?(_ state: NEVPNStatus) {
        
        switch state {
        case NEVPNStatus.connected:
            self = .connected
        case NEVPNStatus.invalid, NEVPNStatus.disconnected :
            self = .disconnected
        case NEVPNStatus.connecting , NEVPNStatus.reasserting:
            self = .connecting
        case NEVPNStatus.disconnecting:
            self = .disconnecting
        default:
            return nil
        }
    }
}
