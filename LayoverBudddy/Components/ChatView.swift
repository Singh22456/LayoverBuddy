//
//  ChatView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 01/08/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = [
        Message(text: "Welcome to Layover Buddy! How can I help you with your travel today?", isUser: false, timestamp: "9:41 AM")
    ]
    @State private var newMessage: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Chat ScrollView
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }

                    Text("Your chat is protected and secured")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                }
                .padding()
            }

            // Input field
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
        }
        .navigationTitle("Chat with Layover Buddy")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6).ignoresSafeArea())
    }

    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        messages.append(Message(text: newMessage, isUser: true, timestamp: "9:42 AM"))
        newMessage = ""
    }
}

// MARK: - Message Bubble View

struct MessageBubble: View {
    let message: Message

    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color.blue : Color(.systemGray5))
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(20)
                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)

            Text(message.timestamp)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.horizontal, message.isUser ? 8 : 0)
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}

#Preview {
    ChatView()
}
