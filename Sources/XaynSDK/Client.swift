//
//  Client.swift
//  
//
//  Created by Peter Stojanowski on 20/10/2022.
//  Copyright © 2022 Xayn. All rights reserved.
//

import Foundation

public typealias PersonalizedDocumentsCompetion = (Result<PersonalizedDocumentsResponse, XaynError>) -> ()
public typealias DefaultCompletion = (Result<Void, XaynError>) -> ()

public protocol Client {
    /// Returns a list of documents personalized for the current user.
    /// Each document contains the id, the score and the properties
    /// that are attached to the document. The score is a value
    /// between 0 and 1 where a higher value means that
    /// the document matches the preferences of the user better.
    ///
    /// - Parameters:
    ///   - completion: The completion handler
    func personalizedDocuments(completion: @escaping PersonalizedDocumentsCompetion)
    
    @available(iOS 13.0.0, macOS 12.0, *)
    func personalizedDocuments() async throws -> PersonalizedDocumentsResponse

    
    /// The positive interaction is used to provide personalized documents to the user.
    ///
    /// - Parameters:
    ///   - documentId: Id of the document
    ///   - completion: The completion handler
    func likeDocument(documentId: String, completion: @escaping DefaultCompletion)
    
    @available(iOS 13.0.0, macOS 12.0, *)
    func likeDocument(documentId: String) async throws
    
    /// Add documents to the system. The system will create a representation
    /// of the document that will be used to match it against the preferences of a user.
    ///
    /// - Parameters:
    ///   - documents: Documents to upload
    ///   - completion: The completion handler
    func addDocuments(_ documents: [IngestedDocument], completion: @escaping DefaultCompletion)
    
    @available(iOS 13.0.0, macOS 12.0, *)
    func addDocuments(_ documents: [IngestedDocument]) async throws
    
    /// Updates the curent `userId` to a new one.
    ///
    /// - Parameters:
    ///   - userId: Id of the user
    ///   - completion: The completion handler
    func updateUserId(_ userId: String)
}

public class XaynClient: Client {
    private(set) var userId: String
    
    public init(userId: String) {
        self.userId = userId
    }
    
    public func personalizedDocuments(completion: @escaping PersonalizedDocumentsCompetion) {
        let request = Request.personalizedDocuments(count: nil)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let statusCode = response?.httpStatusCode else {
                completion(.failure(.unknownError))
                return
            }

            if let data = data {
                if let response = try? JSONDecoder().decode(PersonalizedDocumentsResponse.self, from: data) {
                    completion(.success(response))
                } else {
                    let xaynError = request.errorFromStatusCode(statusCode, message: "Unable to decode the response")
                    completion(.failure(xaynError))
                }
            } else {
                let xaynError = request.errorFromStatusCode(statusCode, message: error?.localizedDescription)
                completion(.failure(xaynError))
            }
        }
        task.resume()
    }
    
    @available(iOS 13.0.0, macOS 12.0, *)
    public func personalizedDocuments() async throws -> PersonalizedDocumentsResponse {
        let request = Request.personalizedDocuments(count: nil)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { throw XaynError.unknownError }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let statusCode = response.httpStatusCode else {
            throw XaynError.unknownError
        }
        
        if let response = try? JSONDecoder().decode(PersonalizedDocumentsResponse.self, from: data) {
            return response
        } else {
            throw request.errorFromStatusCode(statusCode, message: "Unable to decode the response")
        }
    }
        
    public func likeDocument(documentId: String, completion: @escaping DefaultCompletion) {
        let request = Request.likeDocument(documentId: documentId)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let statusCode = response?.httpStatusCode else {
                completion(.failure(.unknownError))
                return
            }
            
            if statusCode.isOK {
                completion(.success(()))
            } else {
                let xaynError = request.errorFromStatusCode(statusCode, message: error?.localizedDescription)
                completion(.failure(xaynError))
            }
        }
        task.resume()
    }
    
    @available(iOS 13.0.0, macOS 12.0, *)
    public func likeDocument(documentId: String) async throws {
        let request = Request.likeDocument(documentId: documentId)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { throw XaynError.unknownError }
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let statusCode = response.httpStatusCode else {
            throw XaynError.unknownError
        }
        if !statusCode.isOK {
            throw request.errorFromStatusCode(statusCode, message: response.description)
        }
    }
    
    public func addDocuments(_ documents: [IngestedDocument], completion: @escaping DefaultCompletion) {
        let request = Request.addDocuments(documents)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let statusCode = response?.httpStatusCode else {
                completion(.failure(.unknownError))
                return
            }
            
            if statusCode.isOK {
                completion(.success(()))
            } else {
                let xaynError = request.errorFromStatusCode(statusCode, message: error?.localizedDescription)
                completion(.failure(xaynError))
            }
        }
        task.resume()
    }
    
    @available(iOS 13.0.0, macOS 12.0, *)
    public func addDocuments(_ documents: [IngestedDocument]) async throws {
        let request = Request.addDocuments(documents)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { throw XaynError.unknownError }
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let statusCode = response.httpStatusCode else {
            throw XaynError.unknownError
        }
        if !statusCode.isOK {
            throw request.errorFromStatusCode(statusCode, message: response.description)
        }
    }
    
    public func updateUserId(_ userId: String) {
        self.userId = userId
    }
}

extension URLResponse {
    var httpStatusCode: Int? {
        guard let httpResponse = self as? HTTPURLResponse else { return nil }
        return httpResponse.statusCode
    }
}

extension Int {
    var isOK: Bool {
        return (200 ..< 300).contains(self)
    }
}
