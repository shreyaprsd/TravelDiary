//
//  TripSpecifics.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 17/08/25.
//

import SwiftUI
import TipKit

struct TripSpecifics: View {
  @State var selectedTrip: TripModel
  @Environment(\.modelContext) var modelContext
  @State var showingBudgetView = false
  @State private var headerImage: Data? = nil
  @State private var budgetSpentInput = ""
  @State private var saveInfoAlert = false

  private var viewModel: TripViewModel {
    TripViewModel(modelContext: modelContext)
  }

  var body: some View {
    ZStack {
      ScrollView {
        VStack {
          HeaderPhotoView(selectedImageData: $headerImage)
            .frame(width: 375, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 25))

          TripTextSpecifics(
            selectedTrip: $selectedTrip,
            budgetSpentInput: $budgetSpentInput,
            showBudgetView: $showingBudgetView
          )
          .padding(12)
          .background(Color(.systemBackground))
        }
      }
      .blur(radius: showingBudgetView ? 5 : 0)

      if showingBudgetView {
        FiscalDetails(
          selectedTrip: selectedTrip,
          showingBudgetView: $showingBudgetView
        )
      }
    }

    .onAppear {
      headerImage = selectedTrip.headerImage
    }

    .onSubmit {
      if !budgetSpentInput.isEmpty {
        viewModel.debouncingSave(
          for: .budget,
          trip: selectedTrip,
          headerImage: headerImage,
          budgetSpent: budgetSpentInput
        )
      }
    }

    .onChange(of: headerImage) { _, newValue in
      let result = viewModel.updateTripDetails(
        selectedTrip,
        headerImage: headerImage,
        notes: selectedTrip.notes,
        budgetSpent: Double(selectedTrip.budgetSpent)
      )
      switch result {
      case .success:
        print("Header image saved!")
      case .failure(let error):
        print("Error saving image: \(error.localizedDescription)")
      }
    }

    .onChange(
      of: selectedTrip.notes,
      { _, newValue in
        viewModel.debouncingSave(
          for: .notes,
          trip: selectedTrip,
          headerImage: headerImage,
          budgetSpent: budgetSpentInput
        )
      }
    )
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.clear, for: .navigationBar)

  }

}

#Preview {
  TripSpecifics(
    selectedTrip: TripModel(
      destination: "Goa",
      startDate: .now,
      budgetEstimate: 6789,
      status: .inProgress,
      days: 8
    )
  )
}
