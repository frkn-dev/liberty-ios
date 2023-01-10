//
//  KeychainService.swift
//  Liberty
//
//  Created by Yury Soloshenko on 10.01.2023.
//

import KeychainAccess
import CryptoKit

class KeychainService {
    
    // MARK: - Singleton
    
    public static let shared = KeychainService()
    
    // MARK: - Properties
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    let keychain: Keychain
    
    // MARK: - Init
    
    init() {
        
        let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "vpn"
        keychain = Keychain(service: bundleID)
    }
    
    // MARK: - Functions
    
    func savePrivateKey(_ privateKey: PrivateKey) {
        guard let privateKeyEncodedData = try? encoder.encode(privateKey.rawRepresentation) else {
            // TODO: Add logging
            return
        }
        do {
            try keychain.set(privateKeyEncodedData, key: "privateKey")
        } catch {
            // TODO: Add logging
        }
    }
    
    func loadPrivateKey() -> PrivateKey? {
        guard let privateKeyData = try? keychain.getData("privateKey") else { return nil }
        guard let privateKeyRaw = try? decoder.decode(Data.self,
                                                   from: privateKeyData),
        let privateKey = try? PrivateKey(rawRepresentation: privateKeyRaw) else {
            // TODO: Add logging
            return nil
        }
        
        return privateKey
    }
}
