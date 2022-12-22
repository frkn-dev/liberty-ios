//
//  LibertyApp.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

@main
struct LibertyApp: App {
    
    var deeplinkParser = DeeplinkParser.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    deeplinkParser.parse(url)
                }
        }
        #if os(macOS)
        .windowResizabilityContentSize()
        #endif
    }
}
