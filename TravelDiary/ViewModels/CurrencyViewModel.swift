//
//  CurrencyViewModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 19/08/25.
//

import Foundation
import SwiftUI

@Observable
class CurrencyViewModel {
  var currencyData: CurrencyModel?
  var baseCurrency = ""
  var targetCurrency = ""
  var amount: Double = 0.0
  var key = Config.exchangeAPIKey
  var errorMessage = ""
  var exchangeRate: Double = 0.0

  func fetchData() {
    guard !key.isEmpty else {
      errorMessage = CurrencyError.invalidAPIKey.errorDescription
      print(errorMessage)
      return
    }
    if let data = currencyData,
      data.baseCode == baseCurrency,
      data.targetCode == targetCurrency
    {
      print("Exchange rates already fetched \(exchangeRate)")
      return
    }

    let urlString =
      "https://v6.exchangerate-api.com/v6/\(key)/pair/\(baseCurrency)/\(targetCurrency)/\(1)"

    guard let url = URL(string: urlString) else {
      errorMessage = CurrencyError.invalidURL.errorDescription
      print(errorMessage)
      return
    }
    URLSession.shared.dataTask(with: url) { data, _, error in
      DispatchQueue.main.async {
        if let error = error {
          print("Error \(error.localizedDescription)")
          return
        }
        guard let data = data else {
          return
        }
        do {
          let currency = try JSONDecoder().decode(
            CurrencyModel.self, from: data)
          self.currencyData = currency
          self.exchangeRate = currency.conversionRate
          print("data decoded")
          print("conversion rate \(currency.conversionRate)")
          print("Last update: \(currency.timeLastUpdateUTC)")
          if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response:")
            print(jsonString)
          }
        } catch {
          self.errorMessage =
            CurrencyError.decodingError.errorDescription
        }
      }
    }
    .resume()
  }

  func convertAmount(_ amount: Double) -> Double {
    return amount * exchangeRate
  }

  enum CurrencyError: Error {
    case invalidURL
    case invalidAPIKey
    case apiError
    case decodingError

    var errorDescription: String {
      switch self {
      case .invalidURL:
        return "Invalid URL"
      case .invalidAPIKey:
        return "Invalid API Key.Please add your api key"
      case .apiError:
        return "API request failed"
      case .decodingError:
        return "Unable to decode the JSON recieved"

      }
    }
  }
}
