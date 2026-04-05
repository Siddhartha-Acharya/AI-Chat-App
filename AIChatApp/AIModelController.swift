//
//  AIModelController.swift
//  AIChatApp
//
//  Created by selegic mac 01 on 24/03/26.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    
    @Published var messages: [APIMessage] = []
    @Published var input: String = ""
    @Published var loading = false
    
    private let service = OpenAIService()
    
    init() {
        messages = AIChatDBManager.shared.fetch()
    }
    
    func send() async {
        guard !input.isEmpty else { return }
        
        var user = APIMessage(
            id: nil,
            role: "user",
            content: input
        )
        
        if let id = AIChatDBManager.shared.insert(user) {
            user.id = id
        }
        
        messages.append(user)
        
        input = ""
        loading = true
        
        do {
            let reply = try await service.sendMessage(messages: messages)
            
            var bot = APIMessage(
                id: nil,
                role: "assistant",
                content: reply
            )
            
            if let id = AIChatDBManager.shared.insert(bot) {
                bot.id = id
            }
            
            messages.append(bot)
            
        } catch {
            print("ERROR:", error)
        }
        
        loading = false
    }
}
