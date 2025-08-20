//
//  ServiceDetailView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 01/08/25.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceCategory
    @ObservedObject private var model = LayoverBuddyDataModel.shared
    
    // One alert state to handle both cases (confirm vs already added)
    @State private var activeAlert: AlertKind? = nil

    var body: some View {
        List(service.facilities ?? []) { facility in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(facility.name)
                        .font(.headline)
                    Text("Terminal: \(facility.terminal)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Nearby: \(facility.nearbyLandmark)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button {
                    // Check if already in My Trip (same rule as model’s de-dupe)
                    if model.myTrip.contains(where: {
                        $0.name == facility.name && $0.terminal == facility.terminal
                    }) {
                        activeAlert = .alreadyAdded(name: facility.name)
                    } else {
                        activeAlert = .confirmAdd(facility: facility)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                        .accessibilityLabel("Add \(facility.name) to My Trip")
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle(service.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .confirmAdd(let facility):
                return Alert(
                    title: Text("Add to My Trip"),
                    message: Text("Do you want to add “\(facility.name)” to your trip?"),
                    primaryButton: .default(Text("Yes")) {
                        model.addToMyTrip(facility)
                    },
                    secondaryButton: .cancel()
                )
            case .alreadyAdded(let name):
                return Alert(
                    title: Text("Already Added"),
                    message: Text("“\(name)” is already in Your Trip."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

/// Local alert driver to keep a single .alert() modifier
private enum AlertKind: Identifiable {
    case confirmAdd(facility: AirportServiceDetail)
    case alreadyAdded(name: String)

    var id: String {
        switch self {
        case .confirmAdd(let facility): return "confirm-\(facility.id)"
        case .alreadyAdded(let name):   return "already-\(name)"
        }
    }
}

#Preview {
    ServiceDetailView(service: ServiceCategory(
        title: "Lounges",
        imageName: "lounges",
        facilities: [
            AirportServiceDetail(name: "Al Mourjan Lounge", terminal: "Terminal 1", nearbyLandmark: "Near Gate C1"),
            AirportServiceDetail(name: "Oryx Lounge", terminal: "Terminal 1", nearbyLandmark: "Duty-Free Zone")
        ]
    ))
}
