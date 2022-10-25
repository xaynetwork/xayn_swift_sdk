//
//  PersonalizedDocumentsResponse.swift
//  
//
//  Created by Peter Stojanowski on 20/10/2022.
//

import Foundation

public struct PersonalizedDocumentsResponse: Decodable {
    public let documents: [PersonalizedDocumentData]
}
