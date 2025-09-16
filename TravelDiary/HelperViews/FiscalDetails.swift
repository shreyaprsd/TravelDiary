//
//  FiscalDetails.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//

import Charts
import SwiftUI

struct FiscalDetails: View {
  var selectedTrip: TripModel
  @Binding var expenseInput: String
  @Binding var isEditing: Bool
  private var budgetChartData: [BudgetChartData] {
    return [
      BudgetChartData(
        category: "Available",
        amount: selectedTrip.moneyleft,
        color: Color(.systemGreen)
      ),
      BudgetChartData(
        category: "Used",
        amount: selectedTrip.budgetSpent,
        color: Color(.systemYellow)
      ),
    ]
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Expenses")
        .font(.system(size: 20, weight: .bold, design: .default))

      if isEditing {
        HStack {
          Text("Recent expense")
          TextField("required", text: $expenseInput)
            .textFieldStyle(.roundedBorder)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        HStack {
          Text("Recent expense")
          Text("₹\(selectedTrip.budgetSpent, specifier: "%.2f")")
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      HStack {
        Rectangle()
          .fill(Color(.systemGreen))
          .frame(width: 16, height: 16)
        Text("Available  ₹\(selectedTrip.moneyleft, specifier: "%.2f")")
          .font(.system(size: 15, weight: .regular, design: .default))
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      HStack {
        Rectangle()
          .fill(Color(.systemYellow))
          .frame(width: 16, height: 16)
        Text("Used ₹\(selectedTrip.budgetSpent , specifier: "%.2f")")
          .font(.system(size: 15, weight: .regular, design: .default))
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()

    VStack(alignment: .center) {
      Chart(budgetChartData, id: \.id) { data in
        SectorMark(angle: .value("Amount", data.amount))
          .foregroundStyle(data.color)
      }
      .frame(width: 198, height: 198)
      .padding()
    }
  }
}

struct BudgetChartData: Identifiable {
  var id = UUID()
  let category: String
  let amount: Double
  let color: Color
}

#Preview {
  FiscalDetails(
    selectedTrip: TripModel(
      startDate: .now,
      budgetEstimate: 100,
      status: .completed,
      days: 34
    ),
    expenseInput: .constant("100"),
    isEditing: .constant(false)
  )
}
