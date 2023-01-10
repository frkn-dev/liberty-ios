//
//  KeysService.swift
//  Liberty
//
//  Created by Yury Soloshenko on 10.01.2023.
//

import CryptoKit

class KeysService {
    
    // MARK: - Singleton
    
    public static let shared = KeysService()
    
    // MARK: - Dependencies
    
    let keychainService = KeychainService.shared
    
    // MARK: - Properties
    
    private var privateKeyCore: Curve25519.KeyAgreement.PrivateKey? {
        return keychainService.loadPrivateKey()
    }
    
    var privateKey: String {
        return privateKeyCore?.rawRepresentation.base64EncodedString(options: .lineLength64Characters) ?? ""
    }
    
    var publicKey: String {
        return privateKeyCore?.publicKey.rawRepresentation.base64EncodedString() ?? ""
    }
    
    // MARK: - Init
    
    init() {
        guard privateKeyCore == nil else { return }
        generateKeys()
    }
    
    // MARK: - Functions
    
    func generateKeys() {
        keychainService.savePrivateKey(PrivateKey())
    }
}
