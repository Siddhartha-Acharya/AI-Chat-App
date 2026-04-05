//
//  AIModelService.swift
//  AIChatApp
//
//  Created by selegic mac 01 on 24/03/26.
//

import Foundation

class OpenAIService {
    
    private let apiKey = "YOUR_NEW_API_KEY"
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    func sendMessage(messages: [APIMessage]) async throws -> String {
        
        let requestMessages = messages.map {
            ["role": $0.role, "content": $0.content]
        }
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": requestMessages
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print(String(data: data, encoding: .utf8) ?? "No data")
        
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        return decoded.choices.first?.message.content ?? "No response"
    }
}
