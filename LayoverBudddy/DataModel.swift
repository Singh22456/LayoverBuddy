//
//  DataModel.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import Foundation

struct FlightInfo {
    let departureAirport: String
    let departureTime: String
    let arrivalAirport: String
    let arrivalTime: String
    let flightDuration: String
    let layovers: [Layover]
}

struct Layover {
    let airport: String
    let duration: String
}
struct LayoverInput {
    var airport: String = ""
    var duration: Date = Date()
    var hours: Int = 0
    var minutes: Int = 0
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: String
}

struct AirportServiceDetail: Identifiable {
    let id = UUID()
    let name: String
    let terminal: String
    let nearbyLandmark: String
}

struct ServiceCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let facilities: [AirportServiceDetail]
}

struct DeletableService: Identifiable {
    var id: String { name }
    let name: String
}

struct UserDetails {
    let name: String
    let age: Int
    let email: String
}

let sampleServices: [ServiceCategory] = [
    ServiceCategory(
        title: "Lounges",
        imageName: "lounges",
        facilities: [
            AirportServiceDetail(name: "Al Mourjan Lounge", terminal: "Terminal 1", nearbyLandmark: "Near Gate C1"),
            AirportServiceDetail(name: "Oryx Lounge", terminal: "Terminal 1", nearbyLandmark: "Near Duty-Free Zone")
        ]
    ),
    ServiceCategory(
        title: "Showers",
        imageName: "showers",
        facilities: [
            AirportServiceDetail(name: "Shower Suite A", terminal: "Terminal 1", nearbyLandmark: "Wellness Area"),
            AirportServiceDetail(name: "Shower Pod Zone", terminal: "Terminal 2", nearbyLandmark: "Near Lounge C")
        ]
    )
]

let sampleUser = UserDetails(name: "Brahmjot Singh", age: 23, email: "brahmjot@example.com")
