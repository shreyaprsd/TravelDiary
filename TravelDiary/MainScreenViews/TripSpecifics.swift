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
    @State var showingBudgetView = false
    @State private var headerImage: Data? = nil
    @State private var budgetSpentInput = ""
    @State var saveInfo = false
    private var viewModel: TripViewModel {
        TripViewModel(modelContext: modelContext)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HeaderPhotoView(selectedImageData: $headerImage)
                        .frame(height: 300)
                        .ignoresSafeArea(edges: .top)
                        .clipped()
                        .padding(.vertical, 16)

                    TripTextSpecifics(
                        selectedTrip: selectedTrip,
                        budgetSpentInput: $budgetSpentInput
                    )
                    .padding(12)
                    .background(Color(.systemBackground))
                    .offset(y: -20)
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
                Button("Budget") {
                    showingBudgetView = true
                }
                .buttonStyle(.bordered)
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    saveTrip()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func saveTrip() {
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
