//
//  MyTripCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct MyTripCardView: View {
    @ObservedObject private var model = LayoverBuddyDataModel.shared

    @State private var isEditing = false
    @State private var serviceToDelete: AirportServiceDetail? = nil   // assumes Identifiable

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("My Trip")
                    .font(.title3).bold()
                Spacer()
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }

            // Subheading
            Text("Planned Layover Services")
                .font(.subheadline)
                .foregroundColor(.gray)

            if model.myTrip.isEmpty {
                // Empty state
                HStack(spacing: 8) {
                    Image(systemName: "tray")
                    Text("Nothing added yet. Plan your Layover")
                }
                .foregroundColor(.gray)
                .padding(.vertical, 4)
            } else {
                // List of Services from model
                ForEach(model.myTrip) { facility in
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(facility.name)
                            Text("Terminal: \(facility.terminal)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()

                        if isEditing {
                            Button {
                                serviceToDelete = facility
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .alert(item: $serviceToDelete) { facility in
            Alert(
                title: Text("Delete Service"),
                message: Text("Remove “\(facility.name)” from your trip?"),
                primaryButton: .destructive(Text("Delete")) {
                    model.removeFromMyTrip(facility)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    MyTripCardView()
}
