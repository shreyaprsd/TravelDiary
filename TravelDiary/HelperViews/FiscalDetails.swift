//
//  FiscalDetails.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//

import SwiftUI

struct FiscalDetails: View {
    var selectedTrip: TripModel
    @Binding var showingBudgetView: Bool
    var body: some View {
        VStack(spacing: 12) {
            Text(
                "Estimated budget: $\(selectedTrip.budgetEstimate.twoDecimalString)"
            )
            Text("Budget spent: $\(selectedTrip.budgetSpent.twoDecimalString)")
            Text("Money left: $\(selectedTrip.moneyleft.twoDecimalString)")
            Text(
                "Percentage of money left: \(selectedTrip.percentageOfMoneyLeft.twoDecimalPlacesNoTrailingZeros)%"
            )
            Button {
                showingBudgetView = false
            } label: {
                Text("Back")
            }
        }

        .padding(40)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
