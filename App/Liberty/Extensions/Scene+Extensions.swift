//
//  Scene+Extensions.swift
//  Liberty
//
//  Created by Yury Soloshenko on 22.12.2022.
//

import SwiftUI

extension Scene {
    
    #if os(macOS)
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
    #endif
}
