//
//  ReminderView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 01/08/25.
//

import SwiftUI

struct ReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reminderTime = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Reminder Time")) {
                    DatePicker("Select Time", selection: $reminderTime, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("Reminder set for \(reminderTime)")
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ReminderView()
}
