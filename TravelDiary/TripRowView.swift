//
//  TripRow.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 11/08/25.
//

import SwiftUI

struct TripRowView: View {
    let trip: TripModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status: \(trip.status.rawValue)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Destination: \(trip.destination)")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Start date: \(trip.startDate, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("Estimated Budget: $\(trip.budgetEstimate, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TripRowView(
        trip: TripModel(
            destination: "London",
            startDate: .now,
            budgetEstimate: 2500.00,
            status: .planned
        )
    )
}
