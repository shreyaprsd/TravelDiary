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
    @State var showingBudgetInputAlert = false
    @State var budgetSpentInput = ""
    @State var daysInput = ""
    @State var showingDaysInputAlert = false
    @State private var headerImage: Data? = nil
    private var viewModel: TripViewModel {
        TripViewModel(modelContext: modelContext)
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("📍\(selectedTrip.destination)")
                    .font(.title)
                    .fontWeight(.bold)

                HStack(spacing: 25) {
                    Text("Duration 🗓️ : \(selectedTrip.days) days")
                        .font(.title2)
                    Button("Add Days") {
                        showingDaysInputAlert = true
                    }
                    .buttonStyle(.bordered)
                }

                HeaderPhotoView(selectedImageData: $headerImage)
                Section {
                    Button("Add money spent") {
                        showingBudgetInputAlert = true
                    }
                    .buttonStyle(.bordered)
                    FiscalDetails(selectedTrip: selectedTrip)
                } header: {
                    Text("Fiscal Details")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                }

                Section {
                    TripSpecificNotes(selectedTrip: selectedTrip)
                } header: {
                    Text("Notes")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .alert("Add expenses", isPresented: $showingBudgetInputAlert) {
            TextField("Enter amount spent", text: $budgetSpentInput)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) {}
            Button("Add") {
                if let amount = Double(budgetSpentInput), amount > 0 {
                    selectedTrip.budgetSpent += amount
                }
                budgetSpentInput = ""
            }

        }
        .alert("Add days", isPresented: $showingDaysInputAlert) {
            TextField("", text: $daysInput)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) {}
            Button("Add") {
                if Int(daysInput) != nil {
                    selectedTrip.days = Int(daysInput) ?? 0
                }
                daysInput = ""
            }
        }
        Button("Save Info") {
            let result = viewModel.updateTripDetails(
                selectedTrip,
                headerImage: headerImage,
                days: selectedTrip.days,
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
        .buttonStyle(.bordered)
        .padding()
        .onAppear {
            headerImage = selectedTrip.headerImage
        }
    }
}

#Preview {
    TripSpecifics(
        selectedTrip: TripModel(
            destination: "London",
            startDate: .now,
            budgetEstimate: 900,
            status: .completed,
            days: 9,
            notes: "",
            budgetSpent: 100
        )
    )

    .modelContainer(for: TripModel.self, inMemory: true)
}
