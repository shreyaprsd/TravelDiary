//
//  TripTextSpecifics.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 21/08/25.
//

import SwiftUI
import TipKit

struct TripTextSpecifics: View {
    @State var selectedTrip: TripModel
    @Environment(\.modelContext) var modelContext
    @Binding var budgetSpentInput: String
    @Binding var showBudgetView: Bool
    private let helperTip = HelperTips()
    private var viewModel: TripViewModel {
        TripViewModel(modelContext: modelContext)
    }
    var body: some View {
        VStack(spacing: 16) {

            Text("📍\(selectedTrip.destination)")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("Duration: \(selectedTrip.days) days")
                .font(.headline)
                .foregroundStyle(.secondary)
            Divider()

            VStack(spacing: 8) {

                TextField("Enter expenditure", text: $budgetSpentInput)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 375)
                    .keyboardType(.decimalPad)
                    .padding()

                Button {
                    showBudgetView = true
                } label: {
                    Text("View Fiscal Details")
                }
            }
            .popoverTip(helperTip)
            Divider()

            TripSpecificNotes(selectedTrip: selectedTrip)
        }
    }
}
