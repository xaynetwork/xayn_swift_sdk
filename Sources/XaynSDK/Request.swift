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
    case personalizedDocuments(count: Int? = 10)
    case likeDocument(documentId: String)
    case addDocuments(_ documents: [IngestedDocument])
}

extension Request {
    static let baseUrlString = "https://z08ifbakyb.execute-api.eu-central-1.amazonaws.com/default"
    static let authorizationToken = "58ph5hPX874ogqV94RwlA1CnhauEH2HOhgNvPiV6"
    
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
    
    private func url(userId: String) -> URL? {
        let path: String
        switch self {
        case .personalizedDocuments:
            path = "/users/\(userId)/personalized_documents"
            
        case .likeDocument:
            path = "/users/\(userId)/interactions"
            
        case .addDocuments:
            path = "/documents"
        }
        
        let urlString = Request.baseUrlString.appending(path)
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
    
    func buildURLRequest(userId: String) -> URLRequest? {
        guard let url = url(userId: userId) else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Request.authorizationToken, forHTTPHeaderField: "authorizationToken")
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        return request
    }
    
    func errorFromStatusCode(_ statusCode: Int) -> XaynError {
        switch self {
        case .personalizedDocuments:
            switch statusCode {
            case 404:
                return .userNotFound
            case 422:
                return .unableToCreateListForUser
            default:
                return .unknownError
            }
            
        case .likeDocument:
            switch statusCode {
            case 400:
                return .invalidUserOrDocumentId
            default:
                return .unknownError
            }
            
        case .addDocuments:
            switch statusCode {
            case 400:
                return .invalidRequest
            case 500:
                return .documentsNotSuccessfullyUploaded
            default:
                return .unknownError
            }
        }
    }
}
