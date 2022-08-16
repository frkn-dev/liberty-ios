//
//  P12Service.swift
//  Liberty
//
//  Created by Yury Soloshenko on 16.08.2022.
//

import Foundation

class P12Service {
    
    // MARK: - Properties
    
    static let shared = P12Service()
    
    // MARK: - .P12 Data
    
    func getP12FromFile() -> Data? {
        guard let rootCertPath = Bundle.main.url(forResource: "vpnclient", withExtension: "p12") else { return nil }
        
        let data = try? Data(contentsOf: rootCertPath)
        
        
        
        return data
    }
    
    // MARK: - Keychain
    
    func saveP12IntoKeychain() {
        
        guard let pkcs12Data = getP12FromFile() else {
            print("Couldn't import pkcs12 Data from file")
            return
        }
        let password = VPNServerSettings.shared.p12Password
        var importResult: CFArray? = nil
        
        let err = SecPKCS12Import(pkcs12Data as NSData, [
            kSecImportExportPassphrase: password
        ] as NSDictionary, &importResult)
        guard err == errSecSuccess else {
            print("Couldn't make import into Keychain object")
            return
        }
        
        let dictionaries = importResult! as NSArray as! [[String:AnyObject]]
        let identity = dictionaries.first![kSecImportItemIdentity as String] as! SecIdentity
        
        let label = NSUUID().uuidString
        let status = SecItemAdd([
            kSecAttrLabel as String: label,
            kSecValueRef as String: identity
        ] as CFDictionary, nil)
        switch status {
        case errSecDuplicateItem:
            print("Keychain item already exists")
        case errSecSuccess:
            print("Keychain item added")
        case errSecNotAvailable:
            var result = "Keychain item could not be added. Your device probably does not have a passcode."
            result += "Set a passcode and try again."
            print(result)
        default:
            print("Keychain add resulted in status: \(status)")
        }
    }
    
    // MARK: - VPN Protocol
    
    func identityReference() -> Data? {

        guard let pkcs12Data = getP12FromFile() else {
            print("Couldn't import pkcs12 Data")
            return nil
        }
        let password = VPNServerSettings.shared.p12Password
        var importResult: CFArray? = nil
        
        let err = SecPKCS12Import(pkcs12Data as NSData, [
            kSecImportExportPassphrase: password
        ] as NSDictionary, &importResult)
        guard err == errSecSuccess else { fatalError() }
        
        let dictionaries = importResult! as NSArray as! [[String:AnyObject]]
        let identity = dictionaries.first![kSecImportItemIdentity as String] as! SecIdentity
        
        var copyResult: AnyObject? = nil
        let importStatus = SecItemCopyMatching([
            kSecValueRef: identity,
            kSecReturnPersistentRef: true
        ] as NSDictionary, &copyResult)
        guard importStatus == errSecSuccess else { fatalError() }
        
        return copyResult as? Data
    }
    
}
