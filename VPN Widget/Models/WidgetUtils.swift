//
//  WidgetUtils.swift
//  VPN WidgetExtension
//
//  Created by Yury Soloshenko on 11.10.2022.
//

import Foundation

public class WidgetUtils {

    static var connectionState: ConnectionState {
        
        guard let savedState = Defaults.ConnectionData.connectionStatus,
              let state = ConnectionState(rawValue: savedState)
        else { return .disconnected }
        
        return state
    }
    
}
