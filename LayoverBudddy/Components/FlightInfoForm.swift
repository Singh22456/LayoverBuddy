//
//  FlightInfoForm.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct EditableFlightForm: View {
    // Dismiss to go back after success
    @Environment(\.dismiss) private var dismiss

    // Flight 1
    @State private var f1DepartureAirport = ""
    @State private var f1ArrivalAirport = ""
    @State private var f1DepartureTime = Date()
    @State private var f1ArrivalTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()

    // Flight 2
    @State private var f2DepartureAirport = ""
    @State private var f2ArrivalAirport = ""
    @State private var f2DepartureTime = Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date()
    @State private var f2ArrivalTime = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date()

    // UI
    @State private var showSuccessAlert = false

    var body: some View {
        Form {
            flight1Section
            flight2Section
            summarySection
            submitSection
        }
        .navigationTitle("Two-Flight Entry")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Itinerary saved", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your two-leg flight has been saved.")
        }
        .onChange(of: f1ArrivalAirport) { newVal in
            // Auto-lock layover airport as Flight 2 departure
            if newVal.trimmed.isEmpty { return }
            f2DepartureAirport = newVal.trimmed
        }
    }

    // MARK: - Sections

    private var flight1Section: some View {
        Section(header: Text("Flight 1")) {
            TextField("Departure Airport (e.g., DEL)", text: $f1DepartureAirport)
                .textInputAutocapitalization(.characters)
            TextField("Arrival Airport (e.g., DXB)", text: $f1ArrivalAirport)
                .textInputAutocapitalization(.characters)

            DatePicker("Departure", selection: $f1DepartureTime, displayedComponents: [.date, .hourAndMinute])
            DatePicker("Arrival", selection: $f1ArrivalTime, displayedComponents: [.date, .hourAndMinute])

            HStack {
                Text("Duration")
                Spacer()
                Text(minutesToHhMm(durationMinutes(f1DepartureTime, f1ArrivalTime)))
                    .foregroundColor(.secondary)
            }
        }
    }

    private var flight2Section: some View {
        Section(header: Text("Flight 2")) {
            // Layover airport lock: show read-only when we know Flight 1 arrival
            if !f1ArrivalAirport.trimmed.isEmpty {
                HStack {
                    Text("Departure Airport")
                    Spacer()
                    Text(f1ArrivalAirport.trimmed)
                        .foregroundColor(.secondary)
                }
            } else {
                TextField("Departure Airport", text: $f2DepartureAirport)
                    .textInputAutocapitalization(.characters)
            }

            TextField("Arrival Airport (e.g., LHR)", text: $f2ArrivalAirport)
                .textInputAutocapitalization(.characters)

            DatePicker("Departure", selection: $f2DepartureTime, displayedComponents: [.date, .hourAndMinute])
            DatePicker("Arrival", selection: $f2ArrivalTime, displayedComponents: [.date, .hourAndMinute])

            HStack {
                Text("Duration")
                Spacer()
                Text(minutesToHhMm(durationMinutes(f2DepartureTime, f2ArrivalTime)))
                    .foregroundColor(.secondary)
            }
        }
    }

    private var summarySection: some View {
        Section(header: Text("Layover & Total")) {
            HStack {
                Text("Layover Airport")
                Spacer()
                Text(layoverAirport.isEmpty ? "—" : layoverAirport)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Layover Duration")
                Spacer()
                Text(minutesToHhMm(layoverMinutes))
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Total Trip Duration")
                Spacer()
                Text(minutesToHhMm(totalTripMinutes))
                    .bold()
            }

            if !airportsMatch {
                Text("Flight 2 departure must match Flight 1 arrival.")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            if hasInvalidDurations {
                Text("Check your times: each arrival must be after its departure.")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            if layoverMinutes < 0 {
                Text("Flight 2 cannot depart before Flight 1 arrives.")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
    }

    private var submitSection: some View {
        Section {
            Button("Save Itinerary") {
                // Build & persist TwoLegFlightInfo
                let first = FlightSegment(
                    departureAirport: f1DepartureAirport.trimmed,
                    arrivalAirport: f1ArrivalAirport.trimmed,
                    departureTime: f1DepartureTime,
                    arrivalTime: f1ArrivalTime
                )
                let second = FlightSegment(
                    departureAirport: layoverAirport, // forced to match F1 arrival
                    arrivalAirport: f2ArrivalAirport.trimmed,
                    departureTime: f2DepartureTime,
                    arrivalTime: f2ArrivalTime
                )
                let itinerary = TwoLegFlightInfo(first: first, second: second)
                LayoverBuddyDataModel.shared.setCurrentTwoLegFlight(itinerary)

                print("Two-leg itinerary saved:", itinerary)
                showSuccessAlert = true
            }
            .disabled(!formValid)
        }
    }

    // MARK: - Computations & Validation

    private var layoverAirport: String {
        f1ArrivalAirport.trimmed.isEmpty ? f2DepartureAirport.trimmed : f1ArrivalAirport.trimmed
    }

    private var layoverMinutes: Int {
        // Non-negative layover between F1 arrival and F2 departure
        let mins = Int(f2DepartureTime.timeIntervalSince(f1ArrivalTime) / 60)
        return max(mins, 0)
    }

    private func durationMinutes(_ dep: Date, _ arr: Date) -> Int {
        max(Int(arr.timeIntervalSince(dep) / 60), 0)
    }

    private var totalTripMinutes: Int {
        durationMinutes(f1DepartureTime, f1ArrivalTime)
        + layoverMinutes
        + durationMinutes(f2DepartureTime, f2ArrivalTime)
    }

    private var airportsMatch: Bool {
        guard !layoverAirport.isEmpty else { return false }
        return layoverAirport.caseInsensitiveCompare(f2DepartureAirport.trimmed.isEmpty ? layoverAirport : f2DepartureAirport.trimmed) == .orderedSame
    }

    private var hasInvalidDurations: Bool {
        // Each segment must have arrival strictly after departure
        f1ArrivalTime <= f1DepartureTime || f2ArrivalTime <= f2DepartureTime
    }

    private var formValid: Bool {
        !f1DepartureAirport.trimmed.isEmpty &&
        !f1ArrivalAirport.trimmed.isEmpty &&
        !f2ArrivalAirport.trimmed.isEmpty &&
        airportsMatch &&
        !hasInvalidDurations &&
        Int(f2DepartureTime.timeIntervalSince(f1ArrivalTime)) >= 0
    }

    private func minutesToHhMm(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return "\(h)h \(m)m"
    }
}

// MARK: - Utils

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

#Preview {
    NavigationStack { EditableFlightForm() }
}
