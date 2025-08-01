//
//  ProfileView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 01/08/25.
//

import SwiftUI

struct ProfileView: View {
    let user: UserDetails

    // Include user in init
    init(user: UserDetails) {
        self.user = user

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer().frame(height: 40)

                    // Profile Image
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)

                    // White Info Card
                    VStack(spacing: 16) {
                        profileRow(label: "Name", value: user.name)
                        profileRow(label: "Age", value: "\(user.age)")
                        profileRow(label: "Email", value: user.email)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func profileRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView(user: sampleUser)
}

