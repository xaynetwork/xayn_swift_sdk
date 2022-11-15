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

        let url = "https://z08ifbakyb.execute-api.eu-central-1.amazonaws.com/default"

        switch function {
        case .personalization:
            await personalization(apiKey: apiKey!, baseUrl: url)
        case .interactions:
            await interactions(apiKey: apiKey!, baseUrl: url)
        case .documents:
            await documents(apiKey: apiKey!, baseUrl: url)
        }
    }

    private func personalization(apiKey : String, baseUrl: String) async {
        print("Calling /users/{user_id}/personalized_documents ...")
        let client = XaynClient(apiKey: apiKey, userId: "r", baseUrl: baseUrl)
        do {
            let response = try await client.personalizedDocuments(count: 5)
            print("Received documents: \(response.documents)")
        } catch {
            print("Received error: \(error)")
        }
    }
    
    private func interactions(apiKey : String, baseUrl: String) async {
        print("Calling /users/{user_id}/interactions ...")
        let client = XaynClient(apiKey: apiKey, userId: "r", baseUrl: baseUrl)
        do {
            try await client.likeDocument(documentId: "abc0001")
            print("Success")
        } catch {
            print("Received error: \(error)")
        }
    }
    
    private func documents(apiKey : String, baseUrl: String) async {
        print("Calling /documents ...")
        let client = XaynClient(apiKey:apiKey, userId: "r", baseUrl: baseUrl)
        let doc = IngestedDocument(id: "abc0001",
                                   snippet: "Snippet of text that will be used to calculate embeddings.",
                                   properties: [
                                    "title": "Document title",
                                    "image_url": "http://example.com/news_image123.jpg",
                                    "link": "http://example.com/this_news123"
                                   ])
        do {
            try await client.addDocuments([doc])
            print("Success")
        } catch {
            print("Received error: \(error)")
        }
    }
}
