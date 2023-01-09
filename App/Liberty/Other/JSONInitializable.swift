//
//  JSONInitializable.swift
//  Liberty
//
//  Created by Yury Soloshenko on 29.12.2022.
//

import SwiftyJSON

public protocol JSONInitializable {
    init?(json: JSON)
}
