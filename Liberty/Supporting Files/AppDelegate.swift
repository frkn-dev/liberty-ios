//
//  AppDelegate.swift
//  Liberty
//
//  Created by Yury Soloshenko on 16.08.2022.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        P12Service.shared.saveP12IntoKeychain()
        
        return true
    }
}
