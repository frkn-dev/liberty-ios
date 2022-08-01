//
//  LibertyApp.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

@main
struct LibertyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(width: UIConstants.windowWidth, height: UIConstants.windowHeight)
                #endif
                .preferredColorScheme(.light)
        }
    }
}
