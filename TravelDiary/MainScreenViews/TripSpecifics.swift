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
  @State private var headerImage: Data? = nil
  @State private var budgetSpentInput = ""
  @State private var saveInfoAlert = false
  @State private var isEditingMode = false
  private var viewModel: TripViewModel {
    TripViewModel(modelContext: modelContext)
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        HeaderPhotoView(
          selectedImageData: $headerImage,
          isEditing: isEditingMode
        )
        .frame(width: 402, height: 211)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .ignoresSafeArea(.container, edges: .top)
        .padding(.top, -50)

        VStack {
          TripTextSpecifics(
            selectedTrip: $selectedTrip,
            budgetSpentInput: $budgetSpentInput,
            isEditing: $isEditingMode
          )
          .padding(8)
        }
      }
    }
    .onAppear {
      headerImage = selectedTrip.headerImage
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.hidden, for: .navigationBar)
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        if isEditingMode {
          Button("Save") {
            saveTripInfo()
            isEditingMode = false
            saveInfoAlert = true

          }
        } else {
          Button("Edit") {
            isEditingMode = true
          }
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
    let result = viewModel.updateTripDetails(
      selectedTrip,
      headerImage: headerImage,
      notes: selectedTrip.notes,
      budgetSpent: selectedTrip.budgetSpent
    )
    switch result {
    case .success:
      print("Trip details saved successfully")
    case .failure(let error):
      print("Error saving trip details: \(error.localizedDescription)")
    }
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
