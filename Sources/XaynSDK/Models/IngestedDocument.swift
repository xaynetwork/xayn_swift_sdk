//
//  IngestedDocument.swift
//  
//
//  Created by Peter Stojanowski on 25/10/2022.
//

import Foundation

public struct IngestedDocument: Encodable {
    public let id: String
    public let snippet: String
    public let properties: [String: String]
}
