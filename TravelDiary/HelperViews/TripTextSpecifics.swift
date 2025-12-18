//
//  TripTextSpecifics.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 21/08/25.
//

import SwiftUI

struct TripTextSpecifics: View {
  @Binding var selectedTrip: TripModel
  @Environment(\.modelContext) var modelContext
  @Binding var budgetSpentInput: String
  @Binding var isEditing: Bool

  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        Text("\(selectedTrip.destinationName)")
          .font(.largeTitle)
          .fontWeight(.heavy)
          .fontWidth(.expanded)
          .padding(.top, 24)
          .padding(.leading, 16)
          .padding(.bottom, 2)

        Text("Duration: \(selectedTrip.days) Days")
          .font(.title3)
          .fontWeight(.regular)
          .lineSpacing(25)
          .foregroundStyle(Color(hex: "#393838"))
          .padding(.leading, 16)

        MapDisplayView(destination: selectedTrip.destination)
          .padding(.top, 18)
          .padding(.leading, 16)
          .padding(.trailing, 15)

      }

      VStack {
        FiscalDetails(
          selectedTrip: selectedTrip,
          expenseInput: $budgetSpentInput,
          isEditing: $isEditing
        )
        TripSpecificNotes(
          selectedTrip: $selectedTrip,
          isEditing: isEditing
        )
      }
    }
  }
}

#Preview {
  TripTextSpecifics(
    selectedTrip: .constant(
      TripModel(
        destination: DestinationModel(name: "Paris"),
        startDate: .now,
        budgetEstimate: 1200,
        status: .completed,
        days: 7,
        notes: "Amazing trip to the City of Light!",
        budgetSpent: 950
      )
    ),
    budgetSpentInput: .constant("950"),
    isEditing: .constant(false)
  )
}
