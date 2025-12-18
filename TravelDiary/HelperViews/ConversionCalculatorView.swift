//
//  ConversionCalculatorView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 22/08/25.
//

import SwiftUI

struct ConversionCalculatorView: View {

  @Environment(\.dismiss) var dismiss
  var viewModel = CurrencyViewModel()
  @State private var baseCode = ""
  @State private var targetCode = ""
  @State private var baseAmount = ""
  @State private var targetAmount = ""
  @State private var isShowingList = false
  @State private var isEditingBaseCurrency = false
  var key = Config.exchangeAPIKey
  @State private var tempSelectedCurrency = ""
  private var formattedDate: String {
    guard let dateString = viewModel.currencyData?.timeLastUpdateUTC else {
      return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    if let date = formatter.date(from: dateString) {
      let displayFormatter = DateFormatter()
      displayFormatter.dateStyle = .short
      displayFormatter.timeStyle = .short
      return displayFormatter.string(from: date)
    }
    return dateString
  }

  var body: some View {
    VStack(spacing: 4) {
      HStack {
        TextField("Amount", text: $baseAmount)
          .keyboardType(.decimalPad)
          .font(.title3)
          .onChange(of: baseAmount) { _, newValue in
            if let amount = Double(newValue) {
              let converted = viewModel.convertAmount(amount)
              targetAmount = String(format: "%.2f", converted)
            }
          }

        Text(baseCode.isEmpty ? "" : getFlagEmoji(from: baseCode))
          .font(.largeTitle)

        Button(action: {
          isEditingBaseCurrency = true
          tempSelectedCurrency = baseCode
          isShowingList = true
        }) {
          Image(systemName: "chevron.up.chevron.down")
            .foregroundColor(.gray)
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
      }
      .padding()

      ZStack {
        Divider()
        Button {
          guard !baseCode.isEmpty && !targetCode.isEmpty else {
            return
          }

          let temp = baseCode
          baseCode = targetCode
          targetCode = temp

          targetAmount = ""

          viewModel.baseCurrency = baseCode
          viewModel.targetCurrency = targetCode
          viewModel.fetchData()

          if let amount = Double(baseAmount), !baseAmount.isEmpty,
            viewModel.exchangeRate > 0
          {
            let converted = viewModel.convertAmount(amount)
            targetAmount = String(format: "%.2f", converted)
          }
        } label: {
          Image(systemName: "arrow.up.arrow.down.circle")
            .font(.system(size: 30))
        }
      }

      HStack {
        TextField(" Converted Amount", text: $targetAmount)
          .font(.title3)
          .disabled(true)

        Text(targetCode.isEmpty ? "" : getFlagEmoji(from: targetCode))
          .font(.largeTitle)

        Button(action: {
          isEditingBaseCurrency = false
          tempSelectedCurrency = targetCode
          isShowingList = true
        }) {
          Image(systemName: "chevron.up.chevron.down")
            .foregroundColor(.gray)
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
      }
      .padding()
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    .padding()

    .onChange(of: isShowingList) {
      if isEditingBaseCurrency {
        baseCode = tempSelectedCurrency
      } else {
        targetCode = tempSelectedCurrency
      }
      if !baseCode.isEmpty && !targetCode.isEmpty {
        viewModel.baseCurrency = baseCode
        viewModel.targetCurrency = targetCode
        viewModel.fetchData()

        if let amount = Double(baseAmount), !baseAmount.isEmpty {
          let converted = viewModel.convertAmount(amount)
          targetAmount = String(format: "%.2f", converted)
        }
      }
    }

    .onChange(of: viewModel.exchangeRate) {
      if let amount = Double(baseAmount), !baseAmount.isEmpty {
        let converted = viewModel.convertAmount(amount)
        targetAmount = String(format: "%.2f", converted)
      }
    }

    .fullScreenCover(isPresented: $isShowingList) {
      NavigationView {
        CurrencyListView(
          selectedCurrency: $tempSelectedCurrency,
          isPresented: $isShowingList
        )
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              isShowingList = false
            } label: {
              Text("Done")
            }
          }
        }
      }
    }

    Text("Rates updated at : \(formattedDate)")
      .font(.body)
      .foregroundStyle(.secondary)
      .padding()
  }
}

#Preview {
  ConversionCalculatorView()
}
