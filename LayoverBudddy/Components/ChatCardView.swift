//
//  ChatCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct ChatCardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Chat with LayoverBuddy")
                    .font(.headline)
                Text("Get help with your flight and layover queries")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Chat button
            Button(action: {
                print("Chat button tapped")
                // Add navigation or sheet here if needed
            }) {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ChatCardView()
}
