//
//  PersonalizedDocumentsResponse.swift
//  
//
//  Created by Peter Stojanowski on 20/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

public struct PersonalizedDocumentsResponse: Decodable {
    public let documents: [PersonalizedDocumentData]
}
