//
//  String+Extensions.swift
//  Liberty
//
//  Created by Yury Soloshenko on 05.11.2022.
//

import Foundation

extension String {
    
    func uppercasedFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
