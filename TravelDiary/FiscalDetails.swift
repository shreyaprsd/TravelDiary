//
//  FiscalDetails.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//

import SwiftUI

struct FiscalDetails: View {
    var selectedTrip: TripModel
    var body: some View {
        VStack {
            Text(
                "Estimated budget : $\(selectedTrip.budgetEstimate.twoDecimalString)"
            )
            Text("Budget spent : $\(selectedTrip.budgetSpent.twoDecimalString)")
            Text("Money left : $\(selectedTrip.moneyleft.twoDecimalString)")
            Text(
                "Percentage of money left: \(selectedTrip.percentageOfMoneyLeft.twoDecimalPlacesNoTrailingZeros)%"
            )
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FiscalDetails(
        selectedTrip: TripModel(
            destination: "London",
            startDate: .now,
            budgetEstimate: 900,
            status: .completed,
            days: 9,
            notes: "hello world",
            budgetSpent: 100
        )
    )
}
