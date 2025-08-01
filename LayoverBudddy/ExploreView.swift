//
//  ExploreView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var selectedCity = "Singapore"
    @State private var searchText = ""

    // Full list of categories (always shown)
    let allCategories: [(title: String, imageName: String)] = [
        ("Lounges", "Image"),
        ("Sleep Pods & Transit Hotels", "Image"),
        ("Gym Access", "Image"),
        ("Showers", "Image"),
        ("Wi-Fi & Coworking", "Image"),
        ("Duty-Free & Dining", "Image"),
        ("Prayer & Medical Rooms", "Image"),
        ("Short City Tours", "Image")
    ]

    // Sample services per city
    var services: [ServiceCategory] {
        switch selectedCity {
        case "Singapore":
            return [
                ServiceCategory(
                    title: "Lounges",
                    imageName: "lounges",
                    facilities: [
                        AirportServiceDetail(name: "SATS Premier Lounge", terminal: "Terminal 1", nearbyLandmark: "Near Gate C3"),
                        AirportServiceDetail(name: "The Green Market Lounge", terminal: "Terminal 2", nearbyLandmark: "Above Food Court")
                    ]),
                ServiceCategory(
                    title: "Showers",
                    imageName: "showers",
                    facilities: [
                        AirportServiceDetail(name: "Shower Suites", terminal: "Terminal 3", nearbyLandmark: "Next to Ambassador Transit Lounge")
                    ])
            ]
        case "Tokyo":
            return [
                ServiceCategory(
                    title: "Lounges",
                    imageName: "lounges",
                    facilities: [
                        AirportServiceDetail(name: "ANA Lounge", terminal: "Terminal 1", nearbyLandmark: "Gate 51 Area"),
                        AirportServiceDetail(name: "Japan Airlines Sakura Lounge", terminal: "Terminal 2", nearbyLandmark: "Near Security Check C")
                    ])
            ]
        default:
            return []
        }
    }

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // Helper: Check if this category exists in current city services
    func serviceFor(title: String) -> ServiceCategory? {
        services.first { $0.title == title }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

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

                    // Grid of all 8 categories
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(allCategories, id: \.title) { item in
                            if let matchedService = serviceFor(title: item.title) {
                                // ✅ Clickable when service exists
                                NavigationLink(destination: ServiceDetailView(service: matchedService)) {
                                    CategoryCard(title: item.title, imageName: item.imageName)
                                }
                            } else {
                                // ❌ Non-clickable grayed-out card
                                CategoryCard(title: item.title, imageName: item.imageName)
                                    .opacity(0.4)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(.systemGray6))
            .scrollContentBackground(.hidden)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.white, for: .navigationBar)
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
