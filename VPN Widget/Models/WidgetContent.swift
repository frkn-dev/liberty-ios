//
//  WidgetContent.swift
//  VPN WidgetExtension
//
//  Created by Yury Soloshenko on 11.10.2022.
//

import Foundation
import WidgetKit

struct WidgetContent: Codable, TimelineEntry {
    
    var date = Date()

    let connectionState: ConnectionState

}
