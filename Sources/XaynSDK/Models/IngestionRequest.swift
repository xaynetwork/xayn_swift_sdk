//
//  IngestionRequest.swift
//  
//
//  Created by Peter Stojanowski on 25/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

struct IngestionRequest: Encodable {
    let documents: [IngestedDocument]
}
