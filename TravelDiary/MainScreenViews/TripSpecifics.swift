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
                        selectedTrip: selectedTrip,
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveTripInfo()
                    saveInfoAlert = true
                }
            }
        }
        .alert("Saved", isPresented: $saveInfoAlert) {
            //empty to use the default OK button
        } message: {
            Text("Trip details saved!")
        }
    }

    private func saveTripInfo() {
        if let amount = Double(budgetSpentInput) {
            selectedTrip.budgetSpent = amount
        }
        let result = viewModel.updateTripDetails(
            selectedTrip,
            headerImage: headerImage,
            notes: selectedTrip.notes,
            budgetSpent: selectedTrip.budgetSpent
        )

        switch result {
        case .success:
            print("Trip details added!")
        case .failure(let error):
            print("Error saving details: \(error.localizedDescription)")
        }
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
