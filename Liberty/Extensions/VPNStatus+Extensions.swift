//
//  VPNStatus+Extensions.swift
//  Liberty
//
//  Created by Yury Soloshenko on 05.11.2022.
//

import TunnelKit
import NetworkExtension

extension VPNStatus {
    
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
