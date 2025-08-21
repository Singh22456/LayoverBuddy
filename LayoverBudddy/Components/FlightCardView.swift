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
            // Two‑flight entry form (saves TwoLegFlightInfo in model)
            EditableFlightForm()
        }
        .onAppear {
            // Safe to call even if persistence wasn't set
            model.loadCurrentFlight()
            model.loadCurrentTwoLegFlight()
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

            if model.currentTwoLegFlight != nil || model.currentFlight != nil {
                Button { showReminderModal = true } label: {
                    Image(systemName: "bell").font(.title2)
                }

                Button { showDeleteAlert = true } label: {
                    Image(systemName: "trash").font(.title2)
                }
                .alert("Delete itinerary?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if model.currentTwoLegFlight != nil {
                            model.clearTwoLegFlight()
                        } else {
                            model.deleteCurrentFlight()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete the saved flight?")
                }
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if let itin = model.currentTwoLegFlight {
            TwoLegDetailsView(itin: itin)
        } else if let f = model.currentFlight {
            FlightDetailsView(
                flight: f,
                durationText: durationText(for: f),
                layoverFormatter: formatMinutes(_:)
            )
        } else {
            EmptyStateView(
                title: "No flight added",
                subtitle: "Tap + to add your flights",
                systemImage: "airplane.circle"
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }

    // MARK: - Local helpers

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

// MARK: - Subviews (Two-Leg)

private struct TwoLegDetailsView: View {
    let itin: TwoLegFlightInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header line: F1 dep airport → F2 arr airport
            Text("\(itin.first.departureAirport) → \(itin.second.arrivalAirport)")
                .font(.headline)

            // Times (F1 dep → F2 arr)
            Text("\(timeString(itin.first.departureTime)) • \(dateString(itin.first.departureTime))  →  \(timeString(itin.second.arrivalTime)) • \(dateString(itin.second.arrivalTime))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Chips for segments + layover
            HStack(spacing: 8) {
                chip("F1 \(minutesToHhMm(itin.first.durationMinutes))")
                chip("Layover \(minutesToHhMm(itin.layoverMinutes)) @ \(itin.layoverAirport)")
                chip("F2 \(minutesToHhMm(itin.second.durationMinutes))")
            }

            Divider()

            HStack {
                Text("Total")
                Spacer()
                Text(minutesToHhMm(itin.totalDurationMinutes)).bold()
            }
            .font(.subheadline)
        }
    }

    // Helpers
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

    private func dateString(_ date: Date) -> String {
        struct Cache {
            static let f: DateFormatter = {
                let d = DateFormatter()
                d.dateFormat = "dd MMM"
                return d
            }()
        }
        return Cache.f.string(from: date)
    }

    private func minutesToHhMm(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return "\(h)h \(m)m"
    }

    private func chip(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
    }
}

// MARK: - Subviews (Single-Leg)

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
