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
          .font(.custom("SF-Pro", size: 20))
          .fontWeight(.bold)
          .fontDesign(.default)
          .padding(.leading, 16)
          .padding(.bottom, 20)
      }
      VStack(alignment: .leading) {
        if isEditing {
          TextEditor(text: $selectedTrip.notes)
            .font(.custom("SF-Pro", size: 17))
            .fontWeight(.regular)
            .fontDesign(.default)
            .lineSpacing(6)
            .foregroundColor(Color(hex: "#393838"))

        } else {
          Text(selectedTrip.notes)
            .font(.custom("SF-Pro", size: 17))
            .fontWeight(.regular)
            .fontDesign(.default)
            .lineSpacing(6)
            .foregroundStyle(Color(hex: "4C4C4C"))
        }
      }
      .frame(width: 354, height: 121)
      .cornerRadius(1)
      .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
      .padding(.top, 11)
      .padding(.bottom, 11)
      .padding(.leading, 16)
      .padding(.trailing, 15)
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
