//
//  UserInteractionData.swift
//  
//
//  Created by Peter Stojanowski on 24/10/2022.
//

import Foundation

enum UserInteractionType: String, Encodable {
    case positive
}

struct UserInteractionData: Encodable {
    let id: String
    let type: UserInteractionType
}
