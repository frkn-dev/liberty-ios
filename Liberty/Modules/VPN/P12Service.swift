//
//  P12Service.swift
//  Liberty
//
//  Created by Yury Soloshenko on 16.08.2022.
//

import Foundation
import UIKit

class P12Service {
    
    // MARK: - Properties
    
    static let shared = P12Service()
    
    // MARK: - .P12 Data
    
    func getP12FromFile() -> Data? {
//        #if DEBUG
//        let p12Name = "dev_fuckrkn1"
//        #else
        let p12Name = "fuckrkn1"
//        #endif
        
        guard let rootCertPath = Bundle.main.url(forResource: p12Name, withExtension: "p12") else { return nil }
        
        let data = try? Data(contentsOf: rootCertPath)
        
        return data
    }
    
    func getPemFromFile() -> Data? {
        guard let rootCertPath = Bundle.main.url(forResource: "ca", withExtension: "pem") else { return nil }
        
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
    
    func workWithPEM() {
        
        guard let path = Bundle.main.path(forResource: "mycert", ofType: "der") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            var status: OSStatus = noErr
            guard let rootCert = SecCertificateCreateWithData(.none, data as CFData) else {
                return
            }
            
            if status == noErr {
                print("Install root certificate success")
            }
            else if status == errSecDuplicateItem {
                print("duplicate root certificate entry")
            }
            else {
                print("install root certificate failure")
            }
            
            let policy = SecPolicyCreateBasicX509()
            var optionalTrust: SecTrust?
            let certArray = [rootCert]
            status = SecTrustCreateWithCertificates(certArray as AnyObject,
                                                    policy,
                                                    &optionalTrust)
            guard status == errSecSuccess else {
                return
            }
            let trust = optionalTrust!
            
            let exportCerts: CFArray = [rootCert] as CFArray
            let exportStatus = SecTrustSetAnchorCertificates(trust,
                                                             exportCerts as CFArray)
            guard exportStatus == errSecSuccess else { fatalError() }
            
            var importCerts: CFArray? = nil
            let importStatus = SecTrustCopyCustomAnchorCertificates(trust,
                                                                    &importCerts)
            guard importStatus == errSecSuccess else { fatalError() }
            
            var error: CFError?

            print("Veryfing result: ", SecTrustEvaluateWithError(trust, &error))
            print(error)
            
            let addquery: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                           kSecValueRef as String: rootCert,
                                           kSecAttrLabel as String: "lt.fuckrkn1.xyz"]
            status = SecItemAdd(addquery as CFDictionary, nil)
            
            print(status)
            
            
        }
        
        catch {
            print("Trust root certificate failure")
        }
    }
    
}
