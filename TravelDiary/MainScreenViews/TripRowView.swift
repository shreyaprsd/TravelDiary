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

      Text("Destination: \(trip.destinationName)")
        .font(.headline)
        .foregroundColor(.primary)

      Text("Start date: \(trip.startDate, style: .date)")
        .font(.caption)
        .foregroundColor(.secondary)

      Text("Estimated Budget: ₹\(trip.budgetEstimate, specifier: "%.2f")")
        .font(.caption)
        .foregroundColor(.secondary)
    }
  }
}

#Preview {
  TripRowView(
    trip: TripModel(
      destination: DestinationModel(name: "London"),
      startDate: .now,
      budgetEstimate: 7890,
      status: .planned,
      days: 8,
      notes: "abcd",
      budgetSpent: 890
    )
  )
}
