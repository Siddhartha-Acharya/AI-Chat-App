//
//  AIModelView.swift
//  AIChatApp
//
//  Created by selegic mac 01 on 24/03/26.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(vm.messages) { msg in
                        BubbleView(message: msg)
                            .id(msg.id ?? Int64.random(in: 1...999999))
                    }
                }
                .onChange(of: vm.messages.count) { _ in
                    if let last = vm.messages.last {
                        proxy.scrollTo(last.id ?? 0)
                    }
                }
            }
            
            if vm.loading {
                ProgressView()
                    .padding()
            }
            
            HStack {
                TextField("Ask anything...", text: $vm.input)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Button {
                    Task {
                        await vm.send()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
    }
}

struct BubbleView: View {
    let message: APIMessage
    
    var body: some View {
        HStack {
            if message.role == "user" { Spacer() }
            
            Text(message.content)
                .padding()
                .background(
                    message.role == "user"
                    ? Color.blue
                    : Color(.systemGray5)
                )
                .foregroundColor(
                    message.role == "user"
                    ? .white
                    : .black
                )
                .cornerRadius(16)
            
            if message.role == "assistant" { Spacer() }
        }
        .padding(.horizontal)
    }
}
