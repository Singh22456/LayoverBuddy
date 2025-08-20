//
//  FlightCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct FlightCardView: View {
    @ObservedObject private var model = LayoverBuddyDataModel.shared

    @State private var showFlightForm = false
    @State private var showReminderModal = false
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            content
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(16)
        .sheet(isPresented: $showReminderModal) {
            // Replace with your real reminder UI
            ReminderView()
        }
        .navigationDestination(isPresented: $showFlightForm) {
            // Your form already saves via LayoverBuddyDataModel.shared.setCurrentFlight(...)
            EditableFlightForm()
        }
        .onAppear {
            // Safe to call even if you didn't add persistence
            model.loadCurrentFlight()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 16) {
            Button { showFlightForm = true } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .padding(8)
                    .background(Color(.white))
                    .clipShape(Circle())
            }

            Spacer()

            if model.currentFlight != nil {
                Button { showReminderModal = true } label: {
                    Image(systemName: "bell").font(.title2)
                }

                Button { showDeleteAlert = true } label: {
                    Image(systemName: "trash").font(.title2)
                }
                .alert("Delete Flight", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) { model.deleteCurrentFlight() }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete the flight added?")
                }
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if let f = model.currentFlight {
            FlightDetailsView(
                flight: f,
                durationText: durationText(for: f),
                layoverFormatter: formatMinutes(_:)
            )
        } else {
            EmptyStateView(
                title: "No flight added",
                subtitle: "Tap + to add your flight details",
                systemImage: "airplane.circle"
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }

    // MARK: - Local helpers

    private func timeString(_ date: Date) -> String {
        struct Cache {
            static let f: DateFormatter = {
                let d = DateFormatter()
                d.dateFormat = "HH:mm"
                return d
            }()
        }
        return Cache.f.string(from: date)
    }

    private func formatMinutes(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return "\(h)h \(m)m"
    }

    private func durationText(for flight: FlightInfo) -> String {
        if let mins = flight.durationMinutes {
            return formatMinutes(mins)
        }
        let mins = max(0, Int(flight.arrivalTime.timeIntervalSince(flight.departureTime) / 60))
        return formatMinutes(mins)
    }
}

// MARK: - Subviews

private struct FlightDetailsView: View {
    let flight: FlightInfo
    let durationText: String
    let layoverFormatter: (Int) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            timeRow
            layovers
        }
    }

    private var timeRow: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(timeString(flight.departureTime))
                    .font(.title3).bold()
                Text(flight.departureAirport)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }

            Spacer()

            VStack(spacing: 4) {
                Text(durationText)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                Image(systemName: "airplane")
                    .foregroundColor(.blue)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(timeString(flight.arrivalTime))
                    .font(.title3).bold()
                Text(flight.arrivalAirport)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
    }

    @ViewBuilder
    private var layovers: some View {
        if !flight.layovers.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Layovers").font(.headline)
                ForEach(Array(flight.layovers.enumerated()), id: \.offset) { _, stop in
                    HStack {
                        Image(systemName: "clock")
                        Text(stop.airport)
                        Spacer()
                        Text(layoverFormatter(stop.minutes))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }

    private func timeString(_ date: Date) -> String {
        struct Cache {
            static let f: DateFormatter = {
                let d = DateFormatter()
                d.dateFormat = "HH:mm"
                return d
            }()
        }
        return Cache.f.string(from: date)
    }
}

private struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 44))
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).foregroundColor(.gray)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FlightCardView()
            .padding()
            .background(Color(.systemGray6))
    }
}
