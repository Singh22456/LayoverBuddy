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
