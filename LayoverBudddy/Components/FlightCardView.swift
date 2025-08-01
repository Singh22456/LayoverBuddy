//
//  FlightCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct FlightCardView: View {
    @State private var showFlightForm = false
    @State private var showReminderModal = false
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Header Buttons
            HStack(spacing: 16) {
                Button(action: {
                    showFlightForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding(8)
                        .background(Color(.white))
                        .clipShape(Circle())
                }

                Spacer()

                Button(action: {
                    showReminderModal = true
                }) {
                    Image(systemName: "bell")
                        .font(.title2)
                }

                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.title2)
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Flight"),
                        message: Text("Are you sure you want to delete the flight added?"),
                        primaryButton: .destructive(Text("Delete")) {
                            print("Flight deleted")
                        },
                        secondaryButton: .cancel()
                    )
                }
            }

            // Flight Time Info
            HStack {
                VStack(alignment: .leading) {
                    Text("08:30")
                        .font(.title3).bold()
                    Text("New York (JFK)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }

                Spacer()

                VStack(spacing: 4) {
                    Text("5h 20m")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Image(systemName: "airplane")
                        .foregroundColor(.blue)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("13:50")
                        .font(.title3).bold()
                    Text("London (LHR)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }

            // Layovers
            VStack(alignment: .leading, spacing: 8) {
                Text("Layovers")
                    .font(.headline)

                HStack {
                    Image(systemName: "clock")
                    Text("Paris (CDG)")
                    Spacer()
                    Text("2h 15m")
                        .foregroundColor(.gray)
                }

                HStack {
                    Image(systemName: "clock")
                    Text("Amsterdam (AMS)")
                    Spacer()
                    Text("1h 45m")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(16)
        .sheet(isPresented: $showReminderModal) {
            ReminderView()
        }
        .background(
            NavigationLink(destination: EditableFlightForm(), isActive: $showFlightForm) {
                EmptyView()
            }
        )
    }
}

#Preview {
    FlightCardView()
}
