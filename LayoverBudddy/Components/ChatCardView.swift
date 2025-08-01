import SwiftUI

struct ChatCardView: View {
    var body: some View {
        NavigationLink(destination: ChatView()) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Chat with LayoverBuddy")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Get help with your flight and layover queries")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    NavigationStack {
        ChatCardView()
    }
}
