//
//  IngestionRequest.swift
//  
//
//  Created by Peter Stojanowski on 25/10/2022.
//

import Foundation

struct IngestionRequest: Encodable {
    let documents: [IngestedDocument]
}
