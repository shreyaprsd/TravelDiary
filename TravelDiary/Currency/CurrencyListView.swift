//
//  CurrencyList.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 24/09/25.
//

import SwiftUI

struct CurrencyListView: View {

  @State var searchText: String = ""
  var viewModel = CurrencyViewModel()
  @Binding var selectedCurrency: String
  @Binding var isPresented: Bool
  let currencyCode = CurrencyCode()
  var filteredData: [(key: String, value: String)] {
    let sortedCurrencies = currencyCode.currencies.sorted(by: {
      $0.key < $1.key
    })

    if searchText.isEmpty {
      return sortedCurrencies
    } else {
      return sortedCurrencies.filter { currency in
        currency.key.localizedCaseInsensitiveContains(searchText)
          || currency.value.localizedCaseInsensitiveContains(
            searchText)
      }
    }
  }

  var body: some View {
    List(filteredData, id: \.value) { currencyName, code in
      HStack(alignment: .center) {
        Text(getFlagEmoji(from: code))
          .font(.title2)
        Spacer()
        Text(currencyName)
          .font(.headline)
        Spacer()
        Text(code)
          .font(.subheadline)

        if code == selectedCurrency {
          Image(systemName: "checkmark")
            .foregroundStyle(.blue)
        }
      }
      .padding()
      .onTapGesture {
        selectedCurrency = code
        isPresented = false
      }
    }
    .searchable(text: $searchText, prompt: "Search currency")
  }
}

#Preview {
  CurrencyListView(
    selectedCurrency: .constant("USD"),
    isPresented: .constant(true)
  )
}
