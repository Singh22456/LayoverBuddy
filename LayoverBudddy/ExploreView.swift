//
//  ExploreView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var selectedCity = "Select City"
    @State private var searchText = ""

    let categories = [
        ("Lounges", "Image"),
        ("Sleep Pods & Transit Hotels", "Image"),
        ("Gym Access", "Image"),
        ("Showers", "Image"),
        ("Wi-Fi & Coworking", "Image"),
        ("Duty-Free & Dining", "Image"),
        ("Prayer & Medical Rooms", "Image"),
        ("Short City Tours", "Image")
    ]

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Search
//                    TextField("Search airports by city or code", text: $searchText)
//                        .padding(12)
//                        .background(Color(.systemGray5))
//                        .cornerRadius(12)
//                        .padding(.horizontal)

                    // Dropdown
                    Menu {
                        Button("Singapore", action: { selectedCity = "Singapore" })
                        Button("Tokyo", action: { selectedCity = "Tokyo" })
                    } label: {
                        HStack {
                            Text(selectedCity)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    // Header
                    Text("Service Categories")
                        .font(.headline)
                        .padding(.horizontal)

                    // Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(categories, id: \.0) { item in
                            CategoryCard(title: item.0, imageName: item.1)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(.systemGray6)) // ✅ Set system background
            .scrollContentBackground(.hidden) // ✅ Hide default scroll background

            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.white, for: .navigationBar) // ✅ NavBar white
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Profile action
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
