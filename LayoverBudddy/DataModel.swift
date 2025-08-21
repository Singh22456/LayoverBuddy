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

// MARK: - Flight Info (Single-Leg)
struct FlightInfo: Identifiable, Codable {
    var id: UUID = UUID()
    // var flightNumber: String
    var departureAirport: String
    var arrivalAirport: String
    var departureTime: Date
    var arrivalTime: Date
    var layoverAirport: String? // keep if you still use it

    // store numeric total duration (minutes)
    var durationMinutes: Int? = nil

    // layovers carry numeric minutes
    var layovers: [Layover] = []

    // convenience formatter if you used flightDuration in UI
    var flightDurationText: String? {
        guard let mins = durationMinutes else { return nil }
        let h = mins / 60
        let m = mins % 60
        return "\(h)h \(m)m"
    }
}

// MARK: - Layover
struct Layover: Codable {
    let airport: String
    let minutes: Int
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
struct AirportServiceDetail: Identifiable, Codable, Equatable, Hashable {
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

// ======================================================================
// NEW: Two-Leg Flight Models & Helpers
// ======================================================================

// One flight segment
struct FlightSegment: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var departureAirport: String
    var arrivalAirport: String
    var departureTime: Date
    var arrivalTime: Date

    /// Minutes between departure and arrival (non-negative, handles order)
    var durationMinutes: Int {
        let mins = Int(arrivalTime.timeIntervalSince(departureTime) / 60)
        return max(mins, 0)
    }
}

// Two-leg itinerary: first + second, with automatic layover
struct TwoLegFlightInfo: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var first: FlightSegment
    var second: FlightSegment

    /// Layover airport is the arrival of the first segment
    var layoverAirport: String { first.arrivalAirport }

    /// Minutes between arrival of first and departure of second (non-negative)
    var layoverMinutes: Int {
        let mins = Int(second.departureTime.timeIntervalSince(first.arrivalTime) / 60)
        return max(mins, 0)
    }

    /// Total trip duration in minutes (first + layover + second)
    var totalDurationMinutes: Int {
        first.durationMinutes + layoverMinutes + second.durationMinutes
    }
}

// ======================================================================
// App-Level Data Model
// ======================================================================

@MainActor
class LayoverBuddyDataModel: ObservableObject {
    static let shared = LayoverBuddyDataModel()

    // Load persisted data on creation
    private init() {
        loadMyTrip()
        loadCurrentFlight()        // single-leg (existing)
        loadCurrentTwoLegFlight()  // two-leg (new)
    }
    
    @Published private(set) var currentUser: UserDetails? = sampleUser
    @Published private(set) var trips: [Trip] = []
    @Published private(set) var services: [ServiceCategory] = sampleServices
    @Published private(set) var reminders: [Reminder] = []
    @Published private(set) var chatHistory: [ChatMessage] = []

    // Single-leg current flight (existing)
    @Published private(set) var currentFlight: FlightInfo? = nil

    // NEW: Two-leg itinerary
    @Published private(set) var currentTwoLegFlight: TwoLegFlightInfo? = nil

    // My Trip: facilities the user added
    @Published private(set) var myTrip: [AirportServiceDetail] = []
    
    // MARK: - User Management
    func updateUserProfile(name: String, age: Int, email: String) {
        guard var user = currentUser else {
            currentUser = UserDetails(name: name, age: age, email: email)
            return
        }
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
    
    func getAllTrips() -> [Trip] {
        return trips
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
    
    func getAllReminders() -> [Reminder] {
        return reminders
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
            if services[index].facilities == nil { services[index].facilities = [] }
            services[index].facilities!.append(newFacility)
        }
    }
    
    func addService(to categoryID: UUID, newService: AirportService) {
        if let index = services.firstIndex(where: { $0.id == categoryID }) {
            if services[index].services == nil { services[index].services = [] }
            services[index].services!.append(newService)
        }
    }
    
    func getAllServices() -> [ServiceCategory] {
        return services
    }
    
    // MARK: - Utility
    func formattedFlightDuration(from departure: Date, to arrival: Date) -> String {
        let interval = arrival.timeIntervalSince(departure)
        let totalMins = max(Int(interval / 60), 0)
        return minutesToHhMm(totalMins)
    }

    func minutesToHhMm(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return "\(h)h \(m)m"
    }
    
    // ==================================================================
    // Current Flight (single flight for FlightCardView) - Existing
    // ==================================================================
    private let kCurrentFlightKey = "current_flight_v1"

    private func persistCurrentFlight() {
        let defaults = UserDefaults.standard
        if let flight = currentFlight,
           let data = try? JSONEncoder().encode(flight) {
            defaults.set(data, forKey: kCurrentFlightKey)
        } else {
            defaults.removeObject(forKey: kCurrentFlightKey)
        }
    }
    
    func loadCurrentFlight() {
        let defaults = UserDefaults.standard
        guard
            let data = defaults.data(forKey: kCurrentFlightKey),
            let flight = try? JSONDecoder().decode(FlightInfo.self, from: data)
        else { return }
        currentFlight = flight
    }

    func setCurrentFlight(_ flight: FlightInfo) {
        currentFlight = flight
        persistCurrentFlight()
    }
    
    func updateCurrentFlight(_ update: (inout FlightInfo) -> Void) {
        guard var f = currentFlight else { return }
        update(&f)
        currentFlight = f
        persistCurrentFlight()
    }
    
    func deleteCurrentFlight() {
        currentFlight = nil
        persistCurrentFlight()
    }
    
    // Optional: computed helper
    var hasCurrentFlight: Bool { currentFlight != nil }

    // ==================================================================
    // NEW: Current Two-Leg Itinerary
    // ==================================================================
    private let kCurrentTwoLegFlightKey = "current_two_leg_flight_v1"

    private func persistCurrentTwoLegFlight() {
        let defaults = UserDefaults.standard
        if let itin = currentTwoLegFlight,
           let data = try? JSONEncoder().encode(itin) {
            defaults.set(data, forKey: kCurrentTwoLegFlightKey)
        } else {
            defaults.removeObject(forKey: kCurrentTwoLegFlightKey)
        }
    }

    func loadCurrentTwoLegFlight() {
        let defaults = UserDefaults.standard
        guard
            let data = defaults.data(forKey: kCurrentTwoLegFlightKey),
            let itin = try? JSONDecoder().decode(TwoLegFlightInfo.self, from: data)
        else { return }
        currentTwoLegFlight = itin
    }

    func setCurrentTwoLegFlight(_ itinerary: TwoLegFlightInfo) {
        currentTwoLegFlight = itinerary
        persistCurrentTwoLegFlight()
        // Optional: if you want only one active at a time, clear single-leg
        // currentFlight = nil
        // persistCurrentFlight()
    }

    func updateCurrentTwoLegFlight(_ update: (inout TwoLegFlightInfo) -> Void) {
        guard var it = currentTwoLegFlight else { return }
        update(&it)
        currentTwoLegFlight = it
        persistCurrentTwoLegFlight()
    }

    func clearTwoLegFlight() {
        currentTwoLegFlight = nil
        persistCurrentTwoLegFlight()
    }

    var hasCurrentTwoLegFlight: Bool { currentTwoLegFlight != nil }
    
    // ==================================================================
    // My Trip (persisted)
    // ==================================================================
    private let kMyTripKey = "myTrip_v1"

    private func persistMyTrip() {
        if let data = try? JSONEncoder().encode(myTrip) {
            UserDefaults.standard.set(data, forKey: kMyTripKey)
        }
    }

    private func loadMyTrip() {
        if let data = UserDefaults.standard.data(forKey: kMyTripKey),
           let saved = try? JSONDecoder().decode([AirportServiceDetail].self, from: data) {
            myTrip = saved
        }
    }

    func addToMyTrip(_ facility: AirportServiceDetail) {
        // De‑dupe by name + terminal (stable identifiers for airport facilities)
        if !myTrip.contains(where: { $0.name == facility.name && $0.terminal == facility.terminal }) {
            myTrip.append(facility)
            persistMyTrip()
        }
    }

    func removeFromMyTrip(_ facility: AirportServiceDetail) {
        myTrip.removeAll { $0.id == facility.id }
        persistMyTrip()
    }

    func clearMyTrip() {
        myTrip.removeAll()
        persistMyTrip()
    }
}
