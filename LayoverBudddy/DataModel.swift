//
//  DataModel.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import Foundation

// MARK: - User
struct UserDetails: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var age: Int
    var email: String
}

// MARK: - Flight Info
struct FlightInfo: Identifiable, Codable {
    var id: UUID = UUID()
//    var flightNumber: String
    var departureAirport: String
    var arrivalAirport: String
    var departureTime: Date
    var arrivalTime: Date
    var layoverAirport: String?
//    var layoverStart: Date?
//    var layoverEnd: Date?

    // Optional additional UI data
    var flightDuration: String? = nil
    var layovers: [Layover] = []
}

// MARK: - Layover
struct Layover: Codable {
    let airport: String
    let duration: String
}

// MARK: - Layover Input (for form entry)
struct LayoverInput {
    var airport: String = ""
    var duration: Date = Date()
    var hours: Int = 0
    var minutes: Int = 0
}

// MARK: - Chat Message
struct ChatMessage: Identifiable, Codable {
    var id: UUID = UUID()
    var sender: String // "user" or "bot"
    var content: String
    var timestamp: Date
}

// MARK: - Message UI Variant
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: String
}

// MARK: - Airport Service Detail (UI variant)
struct AirportServiceDetail: Identifiable, Codable {
    let id = UUID()
    let name: String
    let terminal: String
    let nearbyLandmark: String
}

// MARK: - Service Category (UI variant)
struct ServiceCategory: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var imageName: String

    // For screen-based variant (facilities)
    var facilities: [AirportServiceDetail]? = nil

    // For backend-based variant (services)
    var services: [AirportService]? = nil
}

// MARK: - Airport Service
struct AirportService: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var location: String
    var isFree: Bool
    var imageName: String
    var category: String
}

// MARK: - Deletable Service (for editing)
struct DeletableService: Identifiable {
    var id: String { name }
    let name: String
}

// MARK: - Trip
struct Trip: Identifiable, Codable {
    var id: UUID = UUID()
    var userID: UUID
    var flights: [FlightInfo]
    var notes: String?
}

// MARK: - Reminder
struct Reminder: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var isCompleted: Bool
}

// MARK: - Sample Data
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

// MARK: - App-Level Data Model
class LayoverBuddyDataModel: ObservableObject {
    @Published var currentUser: UserDetails? = sampleUser
    @Published var trips: [Trip] = []
    @Published var services: [ServiceCategory] = sampleServices
    @Published var reminders: [Reminder] = []
    @Published var chatHistory: [ChatMessage] = []
}
