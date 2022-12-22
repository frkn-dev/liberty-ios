//
//  View+Extension.swift
//  Liberty
//
//  Created by Yury Soloshenko on 11.12.2022.
//

import SwiftUI

extension View {
    
    func open(url: String) {
        guard let url = URL(string: url) else {
          return
        }
        
        #if os(iOS)
        UIApplication.shared.open(url, completionHandler: nil)
        #endif
        
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }
    
    func copy(toClipboard text: String) {
        
        #if os(iOS)
        UIPasteboard.general.string = text
        #endif
        
        #if os(macOS)
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.writeObjects([text as NSString])
        #endif
    }
}
