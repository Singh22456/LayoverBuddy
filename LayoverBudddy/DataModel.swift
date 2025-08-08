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

    // MARK: - User Management
    func updateUserProfile(name: String, age: Int, email: String) {
        guard var user = currentUser else { return }
        user.name = name
        user.age = age
        user.email = email
        currentUser = user
    }

    // MARK: - Trip Management
    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }

    func deleteTrip(_ tripID: UUID) {
        trips.removeAll { $0.id == tripID }
    }

    func updateTrip(_ updatedTrip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == updatedTrip.id }) {
            trips[index] = updatedTrip
        }
    }

    func getTrip(by id: UUID) -> Trip? {
        return trips.first { $0.id == id }
    }

    // MARK: - Reminder Management
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }

    func deleteReminder(_ id: UUID) {
        reminders.removeAll { $0.id == id }
    }

    func toggleReminderCompletion(_ id: UUID) {
        if let index = reminders.firstIndex(where: { $0.id == id }) {
            reminders[index].isCompleted.toggle()
        }
    }

    // MARK: - Chat Management
    func addChatMessage(_ message: ChatMessage) {
        chatHistory.append(message)
    }

    func clearChatHistory() {
        chatHistory.removeAll()
    }

    // MARK: - Airport Services
    func updateServiceCategory(_ updatedCategory: ServiceCategory) {
        if let index = services.firstIndex(where: { $0.id == updatedCategory.id }) {
            services[index] = updatedCategory
        }
    }

    func addFacility(to categoryID: UUID, newFacility: AirportServiceDetail) {
        if let index = services.firstIndex(where: { $0.id == categoryID }) {
            services[index].facilities?.append(newFacility)
        }
    }

    func addService(to categoryID: UUID, newService: AirportService) {
        if let index = services.firstIndex(where: { $0.id == categoryID }) {
            services[index].services?.append(newService)
        }
    }

    // MARK: - Utility
    func formattedFlightDuration(from departure: Date, to arrival: Date) -> String {
        let interval = arrival.timeIntervalSince(departure)
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
