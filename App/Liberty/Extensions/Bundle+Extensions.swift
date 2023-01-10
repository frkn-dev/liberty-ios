//
//  Bundle+Extensions.swift
//  Liberty
//
//  Created by Yury Soloshenko on 10.01.2023.
//

import Foundation

extension Bundle {
    
    public var appVersion: String {
        let dictionary = Bundle.main.infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        return version
    }
    
    public var buildVersion: String {
        let dictionary = Bundle.main.infoDictionary
        let version = dictionary?["CFBundleVersion"] as? String ?? "unknown"
        return version
    }
    
    public var appName: String {
        let dictionary = Bundle.main.infoDictionary
        let name = dictionary?["CFBundleName"] as? String ?? "unknown"
        return name
    }
    public var appFullVersion: String {
        return "\(appName) \(appVersion) (\(buildVersion))"
    }
}
