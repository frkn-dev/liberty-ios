//
//  GlobalFunctions.swift
//  Liberty
//
//  Created by Yury Soloshenko on 26.12.2022.
//

import Foundation

public let appGroup = "group.vpn.nezavisimost.Soloshenko"

#if os(macOS)
public let tunnelIdentifier =
"com.nezavisimost.Liberty.Soloshenko.macOSWireGuardNetworkExtension"
#elseif os(iOS)
public let tunnelIdentifier =
"com.nezavisimost.Liberty.Soloshenko.iOSWireGuardNetworkExtension"
#endif
