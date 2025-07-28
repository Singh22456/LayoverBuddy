//
//  FlightCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct FlightCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Header with +, Bell and Trash
            HStack {
                Button(action: {
                    print("Add flight tapped")
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding(8)
                        .background(Color(.white))
                        .clipShape(Circle())
                }

                Spacer()

                Button(action: {
                    print("Reminder tapped")
                }) {
                    Image(systemName: "bell")
                        .font(.title2)
                }

                Button(action: {
                    print("Delete tapped")
                }) {
                    Image(systemName: "trash")
                        .font(.title2)
                }
            }

            // Flight Time Info
            HStack {
                VStack(alignment: .leading) {
                    Text("08:30")
                        .font(.title3)
                        .bold()
                    Text("New York (JFK)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }

                Spacer()

                VStack {
                    Text("5h 20m")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Image(systemName: "airplane")
                        //.rotationEffect(.degrees(90))
                        .foregroundColor(.blue)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("13:50")
                        .font(.title3)
                        .bold()
                    Text("London (LHR)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }

            // Layover Section
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
    }
}


#Preview {
    FlightCardView()
}
