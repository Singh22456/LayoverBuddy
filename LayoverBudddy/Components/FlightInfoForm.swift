//
//  FlightInfoForm.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct EditableFlightForm: View {
    @State private var departureAirport = ""
    @State private var arrivalAirport = ""

    @State private var departureTime = Date()
    @State private var arrivalTime = Date()

    // Flight Duration (hours and minutes)
    @State private var flightHours = 0
    @State private var flightMinutes = 0
    @State private var isFlightDurationExpanded = false

    // Layovers
    @State private var layovers: [LayoverInput] = [LayoverInput()]
    @State private var expandedLayoverIndex: Int? = nil

    var body: some View {
        Form {
            // MARK: - Airports
            Section(header: Text("Airports")) {
                TextField("Departure Airport", text: $departureAirport)
                TextField("Arrival Airport", text: $arrivalAirport)
            }

            // MARK: - Times
            Section(header: Text("Times")) {
                DatePicker("Departure Time", selection: $departureTime, displayedComponents: .hourAndMinute)
                DatePicker("Arrival Time", selection: $arrivalTime, displayedComponents: .hourAndMinute)

                // Flight Duration Picker (Custom)
                Button(action: {
                    withAnimation {
                        isFlightDurationExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("Flight Duration: \(flightHours)h \(flightMinutes)m")
                        Spacer()
                        Image(systemName: isFlightDurationExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                }

                if isFlightDurationExpanded {
                    HStack {
                        Picker("Hours", selection: $flightHours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .clipped()

                        Picker("Minutes", selection: $flightMinutes) {
                            ForEach([0, 15, 30, 45], id: \.self) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .clipped()
                    }
                    .transition(.opacity)
                }
            }

            // MARK: - Layovers
            Section(header: Text("Layovers")) {
                ForEach(layovers.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Layover Airport", text: $layovers[index].airport)

                        Button(action: {
                            withAnimation {
                                expandedLayoverIndex = expandedLayoverIndex == index ? nil : index
                            }
                        }) {
                            HStack {
                                Text("Duration: \(layovers[index].hours)h \(layovers[index].minutes)m")
                                Spacer()
                                Image(systemName: expandedLayoverIndex == index ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                        }

                        if expandedLayoverIndex == index {
                            HStack {
                                Picker("Hours", selection: $layovers[index].hours) {
                                    ForEach(0..<24) { hour in
                                        Text("\(hour)h").tag(hour)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 100)
                                .clipped()

                                Picker("Minutes", selection: $layovers[index].minutes) {
                                    ForEach([0, 15, 30, 45], id: \.self) { minute in
                                        Text("\(minute)m").tag(minute)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 100)
                                .clipped()
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Button(action: {
                    layovers.append(LayoverInput())
                }) {
                    Label("Add Layover", systemImage: "plus.circle")
                }
            }

            // MARK: - Submit
            Section {
                Button("Submit") {
                    let finalFlight = FlightInfo(
                        departureAirport: departureAirport,
                        departureTime: formatted(departureTime),
                        arrivalAirport: arrivalAirport,
                        arrivalTime: formatted(arrivalTime),
                        flightDuration: "\(flightHours)h \(flightMinutes)m",
                        layovers: layovers.map {
                            Layover(
                                airport: $0.airport,
                                duration: "\($0.hours)h \($0.minutes)m"
                            )
                        }
                    )
                    print(finalFlight)
                }
            }
        }
        .navigationTitle("Flight Entry")
        .navigationBarTitleDisplayMode(.inline)
    }

    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    EditableFlightForm()
}
