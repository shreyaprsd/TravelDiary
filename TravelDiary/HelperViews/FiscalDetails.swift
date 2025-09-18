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
        color: Color(hex: "66D575")
      ),
      BudgetChartData(
        category: "Used",
        amount: selectedTrip.budgetSpent,
        color: Color(hex: "FF9E42")
      ),
    ]
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Expenses")
        .font(.custom("SF-Pro", size: 22))
        .fontWeight(.bold)
        .fontDesign(.default)
        .padding(.top, 18)
        .padding(.bottom, 12)
        .padding(.leading, 16)

      if isEditing {
        HStack {
          Text("Recent expense")
            .font(.custom("SF-Pro", size: 14))
            .fontWeight(.regular)
            .fontDesign(.default)
            .foregroundColor(Color(hex: "#000000"))

          TextField("", text: $expenseInput)
            .textFieldStyle(.roundedBorder)
            .frame(width: 120, height: 10)
            .font(.custom("SF-Pro", size: 14))
            .fontWeight(.regular)
            .fontDesign(.default)
            .foregroundColor(Color(hex: "#393838"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
        .padding(.bottom, 7)
      } else {
        HStack {
          Text("Recent expense")
            .font(.custom("SF-Pro", size: 14))
            .fontWeight(.regular)
            .fontDesign(.default)
            .foregroundColor(Color(hex: "#393838"))

          Text("₹\(selectedTrip.budgetSpent, specifier: "%.2f")")
            .font(.custom("SF-Pro", size: 14))
            .fontWeight(.regular)
            .fontDesign(.default)
            .foregroundColor(Color(hex: "#4C4C4C"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
        .padding(.bottom, 7)
      }

      HStack {
        Rectangle()
          .fill(Color(hex: "66D575"))
          .frame(width: 18, height: 19)
          .cornerRadius(4)

        Text("Available ₹\(selectedTrip.moneyleft, specifier: "%.2f")")
          .font(.custom("SF-Pro", size: 12))
          .fontWeight(.medium)
          .fontDesign(.default)
          .foregroundColor(Color(hex: "565151"))
          .lineSpacing(12)
      }
      .frame(width: 200, height: 20, alignment: .leading)
      .padding(.leading, 16)
      .padding(.bottom, 7)
      HStack {
        Rectangle()
          .fill(Color(hex: "FF9E42"))
          .frame(width: 18, height: 19)
          .cornerRadius(4)

        Text("Used ₹\(selectedTrip.budgetSpent , specifier: "%.2f")")
          .font(.custom("SF-Pro", size: 12))
          .fontWeight(.medium)
          .fontDesign(.default)
          .foregroundColor(Color(hex: "565151"))
          .lineSpacing(12)
      }
      .frame(width: 200, height: 20, alignment: .leading)
      .padding(.leading, 16)
      .padding(.bottom, 8)
    }

    VStack(alignment: .center) {
      Chart(budgetChartData, id: \.id) { data in
        SectorMark(angle: .value("Amount", data.amount))
          .foregroundStyle(data.color)
      }
      .frame(width: 198, height: 198)
      .padding(.bottom, 24)
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
