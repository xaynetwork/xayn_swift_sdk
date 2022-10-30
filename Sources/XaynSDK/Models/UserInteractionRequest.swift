//
//  UserInteractionRequest.swift
//  
//
//  Created by Peter Stojanowski on 24/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

struct UserInteractionRequest: Encodable {
    let documents: [UserInteractionData]
}
