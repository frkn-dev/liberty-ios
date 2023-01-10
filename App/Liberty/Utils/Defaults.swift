//
//  Defaults.swift
//  Liberty
//
//  Created by Yury Soloshenko on 10.10.2022.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults(suiteName: appGroup)?.object(forKey: key) as? Data,
                  let value = try? JSONDecoder().decode(T.self, from: data)
            else {
                return defaultValue
            }
            return value
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults(suiteName: appGroup)?.set(encoded, forKey: key)
            }
        }
    }
}

@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    
    struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }
    
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults(suiteName: appGroup)?.object(forKey: key) as? Data else { return defaultValue }
            let value = try? JSONDecoder().decode(Wrapper<T>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                let data = try JSONEncoder().encode(Wrapper(wrapped:newValue))
                UserDefaults(suiteName: appGroup)?.set(data, forKey: key)
            } catch {
                print("User defaults error wrapped value: \(error.localizedDescription)")
            }
        }
    }
}

enum Defaults {
    
    enum ConnectionData {
        
        @UserDefault("ConnectionStatus", defaultValue: nil)
        static var connectionStatus: String?
        
        @UserDefault("WireGuardConfig", defaultValue: nil)
        static var wireGuardConfig: WireGuardConfig?
        
        @UserDefault("LastConnectedCountry", defaultValue: nil)
        static var lastConnectedCountry: Country?
    }
    
    enum AppData {
        
        @UserDefault("LatestAppVersion", defaultValue: nil)
        static var lastAppVersion: String?
        
        @UserDefault("NeedUpdateModels", defaultValue: false)
        static var needUpdateModels: Bool
    }
}
