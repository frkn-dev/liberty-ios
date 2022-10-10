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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    deeplinkParser.parse(url)
            }
        }
    }
}
