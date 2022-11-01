import ArgumentParser
import Foundation
import XaynSDK

enum XaynSDKFunction: String, ExpressibleByArgument {
    case personalization
    case interactions
    case documents
}

@main
struct Repeat: ParsableCommand, AsyncParsableCommand {
    @Argument(help: "The function to run (personalization, interactions, documents).")
    var function: XaynSDKFunction

    mutating func run() async throws {
        switch function {
        case .personalization:
            await personalization()
        case .interactions:
            await interactions()
        case .documents:
            await documents()
        }
    }

    private func personalization() async {
        print("Calling /users/{user_id}/personalized_documents ...")
        let client = XaynClient(userId: "r")
        do {
            let response = try await client.personalizedDocuments()
            print("Received response: \(response)")
        } catch {
            print("Received error: \(error)")
        }
    }
    
    private func interactions() async {
        print("Calling /users/{user_id}/interactions ...")
        let client = XaynClient(userId: "r")
        do {
            try await client.likeDocument(documentId: "document id 0001")
            print("Success")
        } catch {
            print("Received error: \(error)")
        }
    }
    
    private func documents() async {
        print("Calling /documents ...")
        let client = XaynClient(userId: "r")
        let doc = IngestedDocument(id: "document id 0001",
                                   snippet: "Snippet of text that will be used to calculate embeddings.",
                                   properties: ["title": "Document title"])
        do {
            try await client.addDocuments([doc])
            print("Success")
        } catch {
            print("Received error: \(error)")
        }
    }
}
