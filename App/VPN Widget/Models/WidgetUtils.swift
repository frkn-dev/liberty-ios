//
//  WidgetUtils.swift
//  VPN WidgetExtension
//
//  Created by Yury Soloshenko on 11.10.2022.
//

import Foundation
import TunnelKit

public class WidgetUtils {

    static var connectionState: VPNStatus {
        
        guard let savedState = Defaults.ConnectionData.connectionStatus,
              let state = VPNStatus(rawValue: savedState)
        else { return .disconnected }
        
        return state
    }
    
}
