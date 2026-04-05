//
//  AIModel.swift
//  AIChatApp
//
//  Created by selegic mac 01 on 24/03/26.
//

import Foundation

struct OpenAIResponse: Codable {
    let choices: [Choice]   
}

struct Choice: Codable {
    let message: APIMessage
}

struct APIMessage: Codable, Identifiable {
    var id: Int64?
    let role: String
    let content: String
}
