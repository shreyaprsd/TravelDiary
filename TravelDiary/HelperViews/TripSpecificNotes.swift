//
//  TripSpecificNotes.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//

import SwiftUI

struct TripSpecificNotes: View {
  @Binding var selectedTrip: TripModel
  var isEditing = false

  var body: some View {
    VStack(alignment: .leading) {
      VStack(spacing: 4) {
        Text("Notes")
          .font(.system(size: 20, weight: .bold, design: .default))
      }
      ZStack {
        if isEditing {
          TextEditor(text: $selectedTrip.notes)
            .padding()
          if selectedTrip.notes.isEmpty {
            Text(
              "Write whatever is in your mind about this trip..."
            )
            .foregroundColor(.secondary)
          }
        } else {
          Text(selectedTrip.notes)
            .foregroundColor(.secondary)
        }
      }
      .frame(width: 354, height: 121)
      .background(Color(.systemBackground))
      .cornerRadius(1)
      .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
      .padding(.top, 11)
      .padding(.bottom, 11)
      .padding(.trailing, 16)
    }
  }
}

#Preview {
  TripSpecificNotes(
    selectedTrip: .constant(
      TripModel(
        destination: DestinationModel(name: "London"),
        startDate: .now,
        budgetEstimate: 900,
        status: .completed,
        days: 9,
        notes: " ",
        budgetSpent: 100
      )
    )
  )
}
