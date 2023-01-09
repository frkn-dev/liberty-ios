//
//  Countries.swift
//  Liberty
//
//  Created by Yury Soloshenko on 23.12.2022.
//

import Foundation
import SwiftyJSON

struct Country: JSONInitializable, Codable {
    
    // MARK: - Properties
    
    let code: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
    }
    
    // MARK: - Init
    
    init?(json: JSON) {
        guard json.isNotEmpty else { return nil }
        guard
            let code = json["code"].string,
            let name = json["name"].string
        else {
            // TODO: Add logging
            return nil
        }
        self.code = code
        self.name = name
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
    }
    
    public init(code: String = "dev", name: String = "🏴‍☠️ Development") {
        
        self.code = code
        self.name = name
    }
}

extension Country: Hashable {}

