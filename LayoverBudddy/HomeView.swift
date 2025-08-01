//
//  HomeView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showProfile = false  // 👈 navigation trigger

    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.white

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        FlightCardView()
                        MyTripCardView()
                        ChatCardView()
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Welcome, Brahmjot")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfile = true
                    }) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            // NavigationLink triggered by state
            .background(
                NavigationLink(
                    destination: ProfileView(user: UserDetails(name: "Brahmjot Singh", age: 23, email: "brahmjot@example.com")),
                    isActive: $showProfile
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}

#Preview {
    HomeView()
}
