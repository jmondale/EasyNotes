//
//  ClaudeService.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import Foundation

enum ClaudeServiceError: Error {
    case requestFailed(statusCode: Int)
    case emptyResponse
}

struct ClaudeService {

    private static let apiURL = URL(string: "https://api.anthropic.com/v1/messages")!

    static func summarize(title: String, content: String) async throws -> String {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Secrets.claudeAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let prompt = """
        Summarize the following note in one concise sentence of 12 words or fewer. \
        Reply with only the summary, no punctuation at the end, nothing else.

        Title: \(title)
        Content: \(content)
        """

        let body: [String: Any] = [
            "model": "claude-opus-4-6",
            "max_tokens": 60,
            "messages": [["role": "user", "content": prompt]]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw ClaudeServiceError.requestFailed(statusCode: httpResponse.statusCode)
        }

        let decoded = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        guard let summary = decoded.content.first?.text, !summary.isEmpty else {
            throw ClaudeServiceError.emptyResponse
        }
        return summary
    }
}

// MARK: - Response types

private struct ClaudeResponse: Decodable {
    let content: [ContentBlock]
}

private struct ContentBlock: Decodable {
    let text: String
}
