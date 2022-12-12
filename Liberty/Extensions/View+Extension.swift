//
//  View+Extension.swift
//  Liberty
//
//  Created by Yury Soloshenko on 11.12.2022.
//

import SwiftUI

extension View {
    
    func open(url: String) {
        guard let url = URL(string: url) else {
          return
        }
        
        UIApplication.shared.open(url, completionHandler: nil)
    }
}
