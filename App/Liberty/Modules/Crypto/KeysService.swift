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
    
    // MARK: - Properties
    
    private(set) var privateKey = Defaults.Crypto.privateKey {
        didSet {
            Defaults.Crypto.privateKey = privateKey
        }
    }
    
    private(set) var publicKey  = Defaults.Crypto.publicKey {
        didSet {
            Defaults.Crypto.publicKey = publicKey
        }
    }
    
    // MARK: - Init
    
    init() {
        
        guard privateKey.isEmptyOrNil || publicKey.isEmptyOrNil else { return }
        generateKeys()
    }
    
    // MARK: - Functions
    
    func generateKeys() {
        let privateKeyCore = Curve25519.KeyAgreement.PrivateKey()
        
        privateKey = privateKeyCore.rawRepresentation.base64EncodedString(options: .lineLength64Characters)
        publicKey = privateKeyCore.publicKey.rawRepresentation.base64EncodedString()
    }
}
