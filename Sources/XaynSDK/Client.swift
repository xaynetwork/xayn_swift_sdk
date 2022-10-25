//
//  Client.swift
//  
//
//  Created by Peter Stojanowski on 20/10/2022.
//

import Foundation

public protocol Client {
    /// Returns a list of documents personalized for the current user.
    /// Each document contains the id, the score and the properties
    /// that are attached to the document. The score is a value
    /// between 0 and 1 where a higher value means that
    /// the document matches the preferences of the user better.
    func personalizedDocuments(completion: @escaping (PersonalizedDocumentsResponse) -> ())
    
    /// The positive interaction is used to provide personalized documents to the user.
    ///
    /// - Parameters:
    ///   - docuemntId: Id of the document
    func likeDocument(documentId: String)
    
    /// Add documents to the system. The system will create a representation
    /// of the document that will be used to match it against the preferences of a user.
    ///
    /// - Parameters:
    ///   - documents: documents to upload
    func addDocuments(_ documents: [IngestedDocument])
    
    /// Updates the curent `userId` to a new one.
    func updateUserId(_ userId: String)
}

public class XaynClient: Client {
    private(set) var userId: String
    
    public init(userId: String) {
        self.userId = userId
    }
    
    public func personalizedDocuments(completion: @escaping (PersonalizedDocumentsResponse) -> ()) {
        let request = Request.personalizedDocuments(count: nil)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(PersonalizedDocumentsResponse.self, from: data) {
                    completion(response)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
    public func likeDocument(documentId: String) {
        let request = Request.likeDocument(documentId: documentId)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
            } else {
                print("Success")
            }
        }
        task.resume()

    }
    
    public func addDocuments(_ documents: [IngestedDocument]) {
        let request = Request.addDocuments(documents)
        guard let urlRequest = request.buildURLRequest(userId: userId) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
            } else {
                print("Success")
            }
        }
        task.resume()
    }
    
    public func updateUserId(_ userId: String) {
        self.userId = userId
    }
}
