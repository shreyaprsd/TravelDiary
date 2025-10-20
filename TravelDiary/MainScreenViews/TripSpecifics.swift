//
//  TripSpecifics.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 17/08/25.
//

import SwiftUI

struct TripSpecifics: View {
  @State var selectedTrip: TripModel
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var headerImage: Data? = nil
  @State private var budgetSpentInput = ""
  @State private var saveInfoAlert = false
  @State private var isEditingMode = false
  private var viewModel: TripViewModel {
    TripViewModel(
      modelContext: modelContext,
      repository: TripRepository(modelContext: modelContext))
  }

  var body: some View {
    VStack {
      ScrollView {
        HeaderPhotoView(
          selectedImageData: $headerImage,
          isEditing: isEditingMode
        )
        .frame(width: 402, height: 221)
        .clipShape(
          UnevenRoundedRectangle(
            cornerRadii: .init(
              topLeading: 0,
              bottomLeading: 12,
              bottomTrailing: 12,
              topTrailing: 0
            ))
        )
        .padding(.top, -56)

        VStack {
          TripTextSpecifics(
            selectedTrip: $selectedTrip,
            budgetSpentInput: $budgetSpentInput,
            isEditing: $isEditingMode
          )
        }
      }
    }
    .onAppear {
      headerImage = selectedTrip.headerImage
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.hidden, for: .navigationBar)
    .toolbar {
      ToolbarItemGroup(placement: .topBarLeading) {
        Button(action: {
          dismiss()
        }) {
          HStack {
            Image(systemName: "chevron.backward")
            Text("Trips")
          }
        }
      }

      ToolbarItemGroup(placement: .topBarTrailing) {
        if isEditingMode {
          Button("Save") {
            saveTripInfo()
            isEditingMode = false
            saveInfoAlert = true
          }
          .fontWeight(.semibold)
        } else {
          Button("Edit") {
            isEditingMode = true
          }
          .fontWeight(.semibold)
        }
      }
    }

    .alert("Saved", isPresented: $saveInfoAlert) {
      //empty for using default OK button
    } message: {
      Text("Trip details saved!")
    }
  }

  private func saveTripInfo() {
    if let amount = Double(budgetSpentInput) {
      selectedTrip.budgetSpent += amount
    }
    selectedTrip.headerImage = headerImage
    viewModel.updateTripDetailsToDB(
      selectedTrip,
      headerImage: headerImage,
      notes: selectedTrip.notes,
      budgetSpent: selectedTrip.budgetSpent
    )
  }
}

#Preview {
  TripSpecifics(
    selectedTrip:
      TripModel(
        destination: DestinationModel(name: "Paris"),
        startDate: .now,
        budgetEstimate: 6789,
        status: .inProgress,
        days: 8
      )
  )
}
