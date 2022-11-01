//
//  XaynError.swift
//  
//
//  Created by Peter Stojanowski on 25/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

public enum XaynErrorType {
    case unknownError
    case invalidRequest
    case invalidUserId
    case invalidUserOrDocumentId
    case userNotFound
    case unableToCreateListForUser
    case documentsNotSuccessfullyUploaded
}

public struct XaynError: Error {
    let type: XaynErrorType
    let statusCode: Int?
    let message: String?
    
    static var unknownError: XaynError {
        XaynError(type: .unknownError, statusCode: nil, message: nil)
    }
}
