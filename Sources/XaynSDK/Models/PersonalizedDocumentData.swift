//
//  PersonalizedDocumentData.swift
//  
//
//  Created by Peter Stojanowski on 20/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

public struct PersonalizedDocumentData: Decodable {
    public let id: String
    public let score: Int
    public let properties: [String: Any]
    
    enum CodingKeys: String, CodingKey {
        case id
        case score
        case properties
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        score = try values.decode(Int.self, forKey: .score)
        properties = try values.decode([String: Any].self, forKey: .properties)
    }
}

