//
//  TripTextSpecifics.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 21/08/25.
//

import SwiftUI

struct TripTextSpecifics: View {
    @State var selectedTrip: TripModel
    @Environment(\.modelContext) var modelContext
    @Binding var budgetSpentInput: String
    private var viewModel: TripViewModel {
        TripViewModel(modelContext: modelContext)
    }
    var body: some View {
        VStack(spacing: 16) {
            Text("📍\(selectedTrip.destination)")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Duration: \(selectedTrip.days) days")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Enter Expenditure", text: $budgetSpentInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding(.horizontal, 12)

            TripSpecificNotes(selectedTrip: selectedTrip)
        }
    }
}
