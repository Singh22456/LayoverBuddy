//
//  MyTripCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct MyTripCardView: View {
    @State private var selectedServices: [String] = [
        "Lounge",
        "City Tour",
        "Shower"
    ]
    @State private var isEditing = false
    @State private var serviceToDelete: DeletableService? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("My Trip")
                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }

            // Subheading
            Text("Planned Layover Services")
                .font(.subheadline)
                .foregroundColor(.gray)

            // List of Services
            ForEach(selectedServices, id: \.self) { service in
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.blue)
                    Text(service)
                    Spacer()

                    if isEditing {
                        Button(action: {
                            serviceToDelete = DeletableService(name: service)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .alert(item: $serviceToDelete) { service in
            Alert(
                title: Text("Delete Service"),
                message: Text("Are you sure you want to remove \"\(service.name)\" from your trip?"),
                primaryButton: .destructive(Text("Delete")) {
                    selectedServices.removeAll { $0 == service.name }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    MyTripCardView()
}
