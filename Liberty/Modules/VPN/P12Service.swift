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
}
