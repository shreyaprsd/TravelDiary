//
//  Extensions.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//
import SwiftUI

extension Double {
  var twoDecimalString: String {
    return String(format: "%.2f", self)
  }

  var twoDecimalPlacesNoTrailingZeros: String {
    let rounded = (self * 100).rounded() / 100
    return String(format: "%g", rounded)
  }
}

extension Color {
  init(hex: String) {
    var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
    var rgb: UInt64 = 0

    Scanner(string: cleanHexCode).scanHexInt64(&rgb)

    let redValue = Double((rgb >> 16) & 0xFF) / 255.0
    let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
    let blueValue = Double(rgb & 0xFF) / 255.0

    self.init(red: redValue, green: greenValue, blue: blueValue)
  }
}
