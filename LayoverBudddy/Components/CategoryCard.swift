//
//  CategoryCard.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct CategoryCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 100)
                .clipped()
                .cornerRadius(12)

            Text(title)
                .font(.subheadline)
                .frame(width: 140, height: 40, alignment: .topLeading) // ✅ FIX: set fixed height
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CategoryCard(title: "Lounge", imageName: "Image")
}
