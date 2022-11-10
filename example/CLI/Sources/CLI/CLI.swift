import ArgumentParser
import Foundation
import XaynSDK

enum XaynSDKFunction: String, ExpressibleByArgument {
    case personalization
    case interactions
    case documents
}

enum CliError: Error {
    case missingApiKeit(String)
}

@main
struct MainCommand: ParsableCommand, AsyncParsableCommand {
    @Argument(help: "The function to run (personalization, interactions, documents).")
    var function: XaynSDKFunction

    

    mutating func run() async throws {
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"]
        if (apiKey == nil)  {
            throw CliError.missingApiKeit("Missing API_KEY env")
        }

        switch function {
        case .personalization:
            await personalization(apiKey: apiKey!)
        case .interactions:
            await interactions(apiKey: apiKey!)
        case .documents:
            await documents(apiKey: apiKey!)
        }
    }

    private func personalization(apiKey : String) async {
        print("Calling /users/{user_id}/personalized_documents ...")
        let client = XaynClient(apiKey: apiKey, userId: "r")
        do {
            let response = try await client.personalizedDocuments(count: 5)
            print("Received documents: \(response.documents)")
        } catch {
            print("Received error: \(error)")
        }
    }
    
    private func interactions(apiKey : String) async {
        print("Calling /users/{user_id}/interactions ...")
        let client = XaynClient(apiKey: apiKey, userId: "r")
        do {
            try await client.likeDocument(documentId: "document id 0001")
            print("Success")
        } catch {
            print("Received error: \(error)")
        }
    }
    
    private func documents(apiKey : String) async {
        print("Calling /documents ...")
        let client = XaynClient(apiKey:apiKey, userId: "r")
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
