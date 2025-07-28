//
//  MyTripCardView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct MyTripCardView: View {
    let selectedServices: [String] = [
        "Lounge",
        "City Tour",
        "Shower"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("My Trip")
                .font(.title3)
                .bold()
            
            // Subheading
            Text("Planned Layover Services")
                .font(.subheadline)
                .foregroundColor(.gray)

            // Service List
            ForEach(selectedServices, id: \.self) { service in
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.blue)
                    Text(service)
                    Spacer()
                }
            }
            
            // Add Service Button
//            Button(action: {
//                print("Add Service tapped")
//            }) {
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                        .foregroundColor(.blue)
//                    Text("Add Layover Service")
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding(.top, 4)

        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

#Preview {
    MyTripCardView()
}
