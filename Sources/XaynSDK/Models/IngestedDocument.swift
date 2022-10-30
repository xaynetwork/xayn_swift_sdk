//
//  IngestedDocument.swift
//  
//
//  Created by Peter Stojanowski on 25/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

public struct IngestedDocument: Encodable {
    public let id: String
    public let snippet: String
    public let properties: [String: Any]
    
    enum CodingKeys: String, CodingKey {
        case id
        case snippet
        case properties
    }
    
    public init(id: String, snippet: String, properties: [String : Any]) {
        self.id = id
        self.snippet = snippet
        self.properties = properties
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(id, forKey: .id)
        try? container.encodeIfPresent(snippet, forKey: .snippet)
        try? container.encodeIfPresent(properties, forKey: .properties)
    }
}
