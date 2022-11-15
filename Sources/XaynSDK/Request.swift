//
//  Request.swift
//  
//
//  Created by Peter Stojanowski on 24/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET
    case POST
    case PATCH
}

enum Request {
    case personalizedDocuments(count: Int?)
    case likeDocument(documentId: String)
    case addDocuments(_ documents: [IngestedDocument])
}

extension Request {
    private var httpMethod: HttpMethod {
        switch self {
        case .personalizedDocuments:
            return .GET
            
        case .likeDocument:
            return .PATCH
            
        case .addDocuments:
            return .POST
        }
    }
    
    private func url(userId: String, baseUrl : String) -> URL? {
        let path: String
        switch self {
        case .personalizedDocuments:
            path = "/users/\(userId)/personalized_documents"
            
        case .likeDocument:
            path = "/users/\(userId)/interactions"
            
        case .addDocuments:
            path = "/documents"
        }
        
        let urlString = baseUrl.appending(path)
        return URL(string: urlString)
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .personalizedDocuments(let count):
            if let count = count {
                return [URLQueryItem(name: "count", value: "\(count)")]
            }
            return nil
            
        case .likeDocument:
            return nil
            
        case .addDocuments:
            return nil
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .personalizedDocuments:
            return nil
            
        case .likeDocument(let documentId):
            let userInteractionData = UserInteractionData(id: documentId, type: .positive)
            let userInteractionRequest = UserInteractionRequest(documents: [userInteractionData])
            let encoder = JSONEncoder()
            return try? encoder.encode(userInteractionRequest)
            
        case .addDocuments(let documents):
            let ingestionRequest = IngestionRequest(documents: documents)
            let encoder = JSONEncoder()
            return try? encoder.encode(ingestionRequest)
        }
    }
    
    func buildURLRequest(apiKey: String, userId: String, baseUrl: String) -> URLRequest? {
        guard let url = url(userId: userId, baseUrl: baseUrl) else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "authorizationToken")
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        return request
    }
    
    func errorFromStatusCode(_ statusCode: Int, message: String?) -> XaynError {
        let errorType: XaynErrorType
        switch self {
        case .personalizedDocuments:
            switch statusCode {
            case 404:
                errorType = .userNotFound
            case 422:
                errorType = .unableToCreateListForUser
            default:
                errorType = .unknownError
            }
            
        case .likeDocument:
            switch statusCode {
            case 400:
                errorType = .invalidUserOrDocumentId
            default:
                errorType = .unknownError
            }
            
        case .addDocuments:
            switch statusCode {
            case 400:
                errorType = .invalidRequest
            case 500:
                errorType = .documentsNotSuccessfullyUploaded
            default:
                errorType = .unknownError
            }
        }
        return XaynError(type: errorType, statusCode: statusCode, message: message)
    }
}
