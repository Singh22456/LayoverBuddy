//
//  ServiceDetailView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 01/08/25.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceCategory

    var body: some View {
        List(service.facilities) { facility in
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
            .padding(.vertical, 8)
        }
        .navigationTitle(service.title)
        .navigationBarTitleDisplayMode(.inline)
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

