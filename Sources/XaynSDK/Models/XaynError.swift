//
//  XaynError.swift
//  
//
//  Created by Peter Stojanowski on 25/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

public enum XaynError: Error {
    case unknownError
    case invalidRequest
    case invalidUserId
    case invalidUserOrDocumentId
    case userNotFound
    case unableToCreateListForUser
    case documentsNotSuccessfullyUploaded
}
