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

public extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self == nil || self == ""
    }
}
